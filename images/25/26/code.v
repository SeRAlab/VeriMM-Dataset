module data_forwarding (
    input [4:0] src1,
    input [4:0] src2,
    input [4:0] dest_ex,
    input [4:0] dest_mem,
    output reg forward_ex,
    output reg forward_mem
);

always @(*) begin
    forward_ex = 0;
    forward_mem = 0;
    
    if (src1 == dest_ex) begin
        forward_ex = 1;
    end
    
    if (src2 == dest_ex) begin
        forward_ex = 1;
    end
    
    if (src1 == dest_mem) begin
        forward_mem = 1;
    end
    
    if (src2 == dest_mem) begin
        forward_mem = 1;
    end
end

endmodule