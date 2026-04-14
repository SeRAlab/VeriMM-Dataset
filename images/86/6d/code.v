module top_module(
    input [7:0] num1,
    input [7:0] num2,
    input [1:0] ctrl,
    input reset,
    output reg [7:0] res
);always @(*) begin
    case(ctrl)
        2'b00: res = num1 + num2; //Addition
        2'b01: res = num1 - num2; //Subtraction
        2'b10: res = num1 * num2; //Multiplication
        2'b11: begin               //Division
            if(num2 == 0) begin
                res = 8'b00000000; //Divide-by-zero error
            end else begin
                res = num1 / num2; //Integer division
            end
        end
        default: res = 8'b00000000; //Invalid control signal
    endcase
end

always @(posedge reset) begin
    res <= 8'b00000000; //Reset the output
end

endmodule