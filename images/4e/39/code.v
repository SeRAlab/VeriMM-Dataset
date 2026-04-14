module top_module(
    input [3:0]sw,
    input [3:0]btn,
    output [3:0]led
    );assign led = sw | btn;
    
endmodule