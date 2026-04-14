module top_module(
    CLK,
    nRst,
    value
);input CLK, nRst;
output reg [3:0] value;

always @(posedge CLK) begin
    if(nRst == 1'b0) begin
        value <= #1 4'h0;
    end
    else begin
        value <= #1 value + 1;
    end
end

endmodule