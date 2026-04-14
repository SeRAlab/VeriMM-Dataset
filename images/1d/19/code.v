module priority_arbiter(  
    input wire [3:0] req,  
    output reg [3:0] grant  
);  
    always @(*) begin  
        grant = 4'b0000;  
        if (req[0]) grant = 4'b0001;  
        else if (req[1]) grant = 4'b0010;  
        else if (req[2]) grant = 4'b0100;  
        else if (req[3]) grant = 4'b1000;  
    end  
endmodule