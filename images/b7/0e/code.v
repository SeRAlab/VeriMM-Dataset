module top_module(
    input  [9:0] cor_x, cor_y,  
    output [8:0] ind_i          
    );parameter size = 16;

    assign ind_i = (cor_x - 240) / size + (cor_y / size) * 10;

endmodule