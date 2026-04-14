module top_module(
input             clk,
input             rst_n,
input   [31:0]    pc_in,
output  [31:0]    pc_out
);reg   [31:0]   pcreg_out;

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        pcreg_out <= 32'b0;
    else
        pcreg_out <= pc_in;
end

assign pc_out = pcreg_out;

endmodule