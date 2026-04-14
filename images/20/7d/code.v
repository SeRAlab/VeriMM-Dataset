module priority_arbiter(  
    input wire req0,  
    input wire req1,  
    input wire req2,  
    input wire req3,  
    output reg [3:0] grant  
);  

always @(*) begin  
    grant = 4'b0000; // Default no grant  
    if(req0) grant = 4'b0001;  
    else if(req1) grant = 4'b0010;  
    else if(req2) grant = 4'b0100;  
    else if(req3) grant = 4'b1000;  
end  
endmodule