module top_module(input clkp5 , output reg [7:0] actual);reg [20:0] number = 0;
always@(posedge clkp5)
    begin
    number <= {number[19:0] , ~(number[20] ^ number[19])};
    actual <= number % 77;
    end
endmodule