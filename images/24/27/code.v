module mux4to1 (
    input [31:0] bus0,
    input [31:0] bus1,
    input [31:0] bus2,
    input [31:0] bus3,
    input [1:0] sel,
    output reg [31:0] dout
);
    always @(*) begin
        case (sel)
            2'b00: dout = bus0;
            2'b01: dout = bus1;
            2'b10: dout = bus2;
            2'b11: dout = bus3;
            default: dout = 32'b0; // Default case for safety
        endcase
    end
endmodule