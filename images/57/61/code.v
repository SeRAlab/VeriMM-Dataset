module top_module(input clock,
    input [7:0] brightness,
    output driver
    );reg [7:0]counter;
    always @(posedge clock)begin
        counter<= counter+1;
    end
    assign driver= counter<brightness?1'b1:1'b0;
endmodule