module top_module(
    input wire clock,
    input wire PREbar,
    input wire CLRbar,
    input wire Wen,
    input wire [31:0] data,
    output reg [31:0] q,
    output reg [31:0] qbar
);always @(posedge clock) begin
    if (!PREbar) begin
        q <= 32'h00000001;
    end else if (!CLRbar) begin
        q <= 32'h00000000;
    end else if (Wen) begin
        q <= data;
    end
end

assign qbar = ~q;

endmodule