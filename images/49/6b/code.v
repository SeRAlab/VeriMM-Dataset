module top_module (
    input clk,
    input nreset,
    input load,
    input [7:0] data,
    output [7:0] q );reg [7:0] q_reg;

always @(posedge clk or negedge nreset) begin
    if (!nreset)
        q_reg <= 8'b00000000;
    else if (load)
        q_reg <= data;
end

assign q = q_reg;

endmodule