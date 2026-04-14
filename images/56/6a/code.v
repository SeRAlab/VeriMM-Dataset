module shift_register(
    input clk,
    input load,
    input [3:0] data_in,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (load) begin
        q <= data_in;
    end else begin
        q <= q >> 1;
    end
end

endmodule