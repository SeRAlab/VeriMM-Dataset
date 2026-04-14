module top_module(
    offset,
    signExtend_offset
    );input [31:0] offset;
    output reg [63:0] signExtend_offset;
    
    always@(offset)
    begin
        
        if (offset[31:26] == 6'b000101) 
        begin
            signExtend_offset[25:0] = offset[25:0];
            signExtend_offset <= {{38{signExtend_offset[25]}}, signExtend_offset[25:0]};
        end
        else if (offset[31:24] == 8'b10110100)  
        begin
            signExtend_offset[19:0] = offset[23:5];
            signExtend_offset <= {{44{signExtend_offset[19]}}, signExtend_offset[19:0]};
        end
        else
        begin 
             signExtend_offset[9:0] = offset[20:12];
             signExtend_offset <= {{54{signExtend_offset[9]}}, signExtend_offset[9:0]};
        end
    end
endmodule