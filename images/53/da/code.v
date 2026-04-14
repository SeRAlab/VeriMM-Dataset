module top_module(
    input CLK,
    input EN,
    input TE,
    output ENCLK
);reg Q;
wire G;

assign G = EN & ~TE;
assign ENCLK = G & CLK;

always @(posedge CLK or negedge TE) begin
    if (!TE) begin
        Q <= 1'b0;
    end else begin
        Q <= G ^ Q;
    end
end

endmodule