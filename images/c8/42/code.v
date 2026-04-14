module mux2_1 (
    input [7:0] input1,
    input [7:0] input2,
    input select,
    output [7:0] selected_out
    );

    assign selected_out = select ? input2 : input1;
    
endmodule