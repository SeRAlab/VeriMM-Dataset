module priority_arbiter(  
    input wire req0,  
    input wire req1,  
    input wire req2,  
    output reg [1:0] grant  
);  
    always @(*) begin  
        if (req0)  
            grant = 2'b00; // grant req0  
        else if (req1)  
            grant = 2'b01; // grant req1  
        else if (req2)  
            grant = 2'b10; // grant req2  
        else  
            grant = 2'b11; // no request  
    end  
endmodule