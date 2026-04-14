module mac_address_comparator(  
    input [4:0] mac1,  
    input [4:0] mac2,  
    output reg equal  
);  

always @(*) begin  
    if (mac1 == mac2)  
        equal = 1'b1;  
    else  
        equal = 1'b0;  
end  
endmodule