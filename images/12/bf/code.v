module divide_by_2 (
    input wire clk,
    input wire rst,
    input wire data_in,
    output reg data_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 0;
        end else begin
            data_out <= data_in; // Output is same as input because we're dividing by 2
        end
    end
endmodule