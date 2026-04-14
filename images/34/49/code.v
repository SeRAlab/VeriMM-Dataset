module data_forwarding (
    input [4:0] src1, // Source register 1
    input [4:0] src2, // Source register 2
    input [4:0] dest, // Destination register
    input [31:0] exec_val, // Value from execution stage
    output reg [31:0] out1, // Forwarded value for source 1
    output reg [31:0] out2  // Forwarded value for source 2
);

    always @(*) begin
        // Forwarding for source 1
        if (src1 == dest)
            out1 = exec_val;
        else
            out1 = 32'b0; // Assuming zero value if not forwarded

        // Forwarding for source 2
        if (src2 == dest)
            out2 = exec_val;
        else
            out2 = 32'b0; // Assuming zero value if not forwarded
    end
endmodule