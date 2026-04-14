module top_module(y, x0, x1);output y;
    input x0, x1;
    
    assign y = x0 | x1;endmodule