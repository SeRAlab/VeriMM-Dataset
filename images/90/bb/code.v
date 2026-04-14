module loadable_counter(
    input wire clk,
    input wire rst_n,
    input wire enable,
    input wire load,
    input wire [7:0] d,
    output reg [7:0] q
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        q <= 8'b00000000;
    end else if (load) begin
        q <= d;
    end else if (enable) begin
        q <= q + 8'b00000001;
    end
end

endmodule