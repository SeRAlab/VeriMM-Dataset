module data_latch2 (
    input clk,
    input reset,
    input [1:0] data_in,
    output reg [1:0] data_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 2'b00;
        end else begin
            data_out <= data_in;
        end
    end
endmodule