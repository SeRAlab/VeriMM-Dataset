module hazard_detection (
    input [4:0] src1,        // Destination register of instruction 1
    input [4:0] src2,        // Source register of instruction 2
    input write_enable,       // Write enable signal for instruction 1
    output hazard             // Hazard signal
);
    assign hazard = (write_enable && (src1 == src2));
endmodule