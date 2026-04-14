module divide_by_2 (
    input wire clk,
    input wire reset,
    input wire data_in,
    output reg data_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 1'b0;
        end else begin
            data_out <= data_in; // Shift right by 1 (divide by 2)
        end
    end
endmodule