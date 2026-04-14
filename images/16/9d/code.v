module mux8to1 (  
    input wire [7:0] I, // 8 inputs  
    input wire [2:0] S, // 3 select lines  
    output wire Y      // output  
);  
    assign Y = I[S]; // Select the appropriate input based on S  
endmodule