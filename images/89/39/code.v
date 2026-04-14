module parallel_load_register_16bit(
    input wire clk,
    input wire reset,
    input wire load,
    input wire [15:0] data_in,
    output reg [15:0] q
    );

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 16'b0000000000000000;
    end else if (load) begin
        q <= data_in;
    end
end

endmodule