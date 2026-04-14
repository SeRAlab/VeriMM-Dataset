module dwt (
    input clk,
    input rst,
    input [3:0] data_in,
    output reg [3:0] approx,
    output reg [3:0] detail
);
    reg [3:0] data_reg [0:3]; // 4-element array to hold input data
    reg [1:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
        end else if (count < 4) begin
            data_reg[count] <= data_in; // Capture input data
            count <= count + 1;
        end else if (count == 4) begin
            approx <= (data_reg[0] + data_reg[1]) >> 1; // Approximation
            detail <= (data_reg[2] - data_reg[3]) >> 1; // Detail
            count <= count + 1; // Done processing
        end
    end
endmodule