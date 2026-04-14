module mux8to1(  
    input [7:0] I, // 8 inputs  
    input [2:0] S, // 3 select lines  
    output Y       // output  
);  
    assign Y = I[S]; // Select input based on select lines  
endmodule