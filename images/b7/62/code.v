module reg8bit (
    input [7:0] data_in,
    input clk,
    input reset,
    output reg [7:0] data_out
);always @(posedge clk or posedge reset) begin
    if (reset) begin
        data_out <= 8'b0;
    end else begin
        data_out <= data_in;
    end
end

endmodule