module top_module(
    input clk,
    input we,
    input [7:0] d_in,
    input [2:0] adr,
    output reg [7:0] d_out
);reg [7:0] reg_file [0:7];

always @(posedge clk) begin
    if (we) begin
        reg_file[adr] <= d_in;
    end
    d_out <= reg_file[adr];
end

endmodule