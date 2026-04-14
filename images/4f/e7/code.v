module data_latch (
    input clk,
    input reset,
    input [3:0] data_in,
    output reg [3:0] data_out
);

    always @(negedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 4'b1111;
        end else begin
            data_out <= data_in;
        end
    end
endmodule