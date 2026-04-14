module top_module(
    AregSticky,
    AregLSBSN,
    AregLSBDB,
    AregFPMSBP1,
    SNnotDB,
    TrueIEEEAregLSB,
    StickyForSR1
);input [1:0] AregSticky; // Two LSBs of Areg
input [1:0] AregLSBSN;  // Two LSBs of Areg for IEEE single length
input [1:0] AregLSBDB;  // Two LSBs of Areg for IEEE double length
input AregFPMSBP1;      // Fraction overflow bit (ie 4.0 < Areg <= 2.0)
input SNnotDB;
output TrueIEEEAregLSB;
output StickyForSR1;

wire [1:0] selectedLSB;
assign selectedLSB = SNnotDB ? AregLSBSN : AregLSBDB;

// Simple implementation of ME_OR2 as a 2-input OR gate
wire stickyOR_output;
assign stickyOR_output = AregSticky[1] | AregSticky[0];
assign StickyForSR1 = stickyOR_output;

assign TrueIEEEAregLSB = selectedLSB[0];

endmodule