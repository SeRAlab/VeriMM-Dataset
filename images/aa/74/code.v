module top_module(
    Y   ,
    A1  ,
    A2  
);output Y   ;
    input  A1  ;
    input  A2  ;
    
    // Use an internal wire for the AND operation
    assign Y = A1 & A2;  // Simple AND gate implementation

endmodule