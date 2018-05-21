using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SevenZip;

namespace BMI.SevenZip.Archive
{
    public class LZMA
    {
        public static void CompressFile(string fileName)
        {

            Int32 dictionary = 1 << 23;

            Int32 posStateBits = 2;
            Int32 litContextBits = 3; // for normal files
                                      // UInt32 litContextBits = 0; // for 32-bit data
            Int32 litPosBits = 0;
            // UInt32 litPosBits = 2; // for 32-bit data
            Int32 algorithm = 2;
            Int32 numFastBytes = 128;

            string mf = "bt4";

            bool eos = false;

            CoderPropID[] propIDs =
                {
                    CoderPropID.DictionarySize,
                    CoderPropID.PosStateBits,
                    CoderPropID.LitContextBits,
                    CoderPropID.LitPosBits,
                    CoderPropID.Algorithm,
                    CoderPropID.NumFastBytes,
                    CoderPropID.MatchFinder,
                    CoderPropID.EndMarker
                };

            object[] properties =
                {
                    (Int32)(dictionary),
                    (Int32)(posStateBits),
                    (Int32)(litContextBits),
                    (Int32)(litPosBits),
                    (Int32)(algorithm),
                    (Int32)(numFastBytes),
                    mf,
                    eos
                };


            Compression.LZMA.Encoder encoder = new Compression.LZMA.Encoder();
            encoder.SetCoderProperties(propIDs, properties);
            encoder.WriteCoderProperties(outStream);
            Int64 fileSize;
        }
    }
}
