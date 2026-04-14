module top_module(
    input [2:0] SW,
    output LED
    );assign LED = SW[0];    
    assign LED = SW[1];
    
endmodule