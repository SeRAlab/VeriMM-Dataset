module data_forwarding_unit (  
    input [4:0] src1,  
    input [4:0] src2,  
    input [4:0] dst,  
    input forward_src1,  
    input forward_src2,  
    output reg [4:0] out_src1,  
    output reg [4:0] out_src2  
);  
    always @(*) begin  
        out_src1 = forward_src1 ? dst : src1;  
        out_src2 = forward_src2 ? dst : src2;  
    end  
endmodule