module top_module(
    clk,
    data,
    ce,
    a,
    q
);parameter DATA_WIDTH = 8;
parameter ADDR_WIDTH = 2; // Changed to accommodate address range
parameter DEPTH = 2;

input clk;
input [DATA_WIDTH-1:0] data;
input ce;
input [ADDR_WIDTH-1:0] a;
output reg [DATA_WIDTH-1:0] q;

reg [DATA_WIDTH-1:0] SRL_SIG [0:DEPTH-1];
integer i;

always @ (posedge clk) begin
    if (ce) begin
        for (i = DEPTH-1; i > 0; i = i - 1) // Changed loop to prevent out-of-bounds
            SRL_SIG[i] <= SRL_SIG[i-1];
        SRL_SIG[0] <= data;
    end
end

always @* begin // Continuously assign q based on address
    case (a)
        2'b00: q = SRL_SIG[0];
        2'b01: q = SRL_SIG[1];
        default: q = {DATA_WIDTH{1'b0}}; // Output zero for out of bounds
    endcase
end

endmodule