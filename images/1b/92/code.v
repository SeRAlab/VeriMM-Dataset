module divide_by_4 (
    input clk,
    input rst,
    output reg [1:0] quotient
);
    reg [1:0] counter;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 2'b00;
            quotient <= 2'b00;
        end else if (counter == 2'b11) begin
            counter <= 2'b00;
        end else begin
            counter <= counter + 1;
            quotient <= counter;
        end
    end
endmodule