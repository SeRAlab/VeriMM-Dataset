module monte_carlo_square(  
    input [4:0] random_input,  
    output reg [9:0] square_output  
);  
    always @(*) begin  
        square_output = random_input * random_input;  
    end  
endmodule