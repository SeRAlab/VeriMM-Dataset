module top_module(
    input clk,
    input sample,
    input shiftIn,
    input [6:0] addr,
    output shiftOut,
    output dataOut
);reg [127:0] shiftReg;

assign dataOut = shiftReg[addr];
assign shiftOut = shiftReg[127];

always @(posedge clk) begin
    if (sample) begin
        shiftReg <= {shiftReg[126:0], shiftIn};
    end
end

endmodule