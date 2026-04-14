module top_module( input in, output out );wire in_bar;
    assign in_bar = ~in;
    assign out = in & in_bar;
endmodule