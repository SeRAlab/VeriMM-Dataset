module register_16bit (
    input wire clk,
    input wire reset,
    input wire [15:0] data_in,
    output reg [15:0] data_out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        data_out <= 16'b0;
    end else begin
        data_out <= data_in;
    end
end

endmodule