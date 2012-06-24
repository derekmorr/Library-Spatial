/*
Copyright 2012 Green Code LLC.
All rights reserved.

Contributers:
  James Domingo, Green Code LLC

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.
3. Neither the names of the copyright holders nor the names of their
   contributors may be used to endorse or promote products derived from
   this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/


using Microsoft.Build.Framework;
using Microsoft.Build.Utilities;
using MSBuild.Community.Tasks.Properties;
using System.IO;
using System.Security.Cryptography;

namespace MSBuild.Community.Tasks
{
    /// <summary>
    /// Compute the hash for a file.
    /// </summary>
    /// <example>Compute the SHA1 hash for a file.
    /// <code><![CDATA[
    /// <Hash FilePath="path\to\a\file.zip" Algorithm="SHA1">
    ///   <Output TaskParameter="Result" Property="FileHash"/>
    /// </Hash/>
    /// ]]></code>
    /// </example>
    public class Hash : Task
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="Hash"/> class.
        /// </summary>
        public Hash()
        {
        }

        /// <summary>
        /// Gets or sets the path of the file to compute the hash of.
        /// </summary>
        /// <value>The path of the file.</value>
        [Required]
        public string FilePath { get; set; }

        /// <summary>
        /// Gets or sets the name of the hash algorithm.
        /// </summary>
        /// <value>
        /// <c>"MD5"</c>, <c>"SHA1"</c>, <c>"SHA256"</c>, <c>"SHA384"</c>,
        /// <c>"SHA512"</c>
        /// </value>
        [Required]
        public string Algorithm { get; set; }

        /// <summary>
        /// Gets or sets the computed hash.
        /// </summary>
        /// <value>The hash computed for the file.</value>
        [Output]
        public string Result { get; set; }

        /// <summary>
        /// When overridden in a derived class, executes the task.
        /// </summary>
        /// <returns>
        /// true if the task successfully executed; otherwise, false.
        /// </returns>
        public override bool Execute()
        {
            HashAlgorithm hashAlg = HashAlgorithm.Create(this.Algorithm);
            if (hashAlg == null)
            {
                Log.LogError("Unknown hash algorithm \"{0}\"", this.Algorithm);
                return false;
            }
            try
            {
                FileStream fileStream = new FileStream(this.FilePath, FileMode.Open);
                byte[] hash = hashAlg.ComputeHash(fileStream);
                fileStream.Close();
                StringWriter strWriter = new StringWriter();
                foreach (byte b in hash) {
                    strWriter.Write("{0:X2}", b);
                }
                this.Result = strWriter.ToString();
                return true;
            }
            catch (System.Exception ex)
            {
                Log.LogErrorFromException(ex, false);
                return false;
            }
        }
    }
}
