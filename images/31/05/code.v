module data_forwarding_unit(  
    input [4:0] rs1,  
    input [4:0] rs2,  
    input [4:0] rd_mem,  
    input [4:0] rd_alu,  
    input mem_read,  
    input alu_ready,  
    input [31:0] alu_out,  
    input [31:0] mem_out,  
    output reg [31:0] forwarded_data  
);  

always @(*) begin  
    forwarded_data = 32'b0;  
    if (mem_read && (rd_mem != 0) && (rs1 == rd_mem)) begin  
        forwarded_data = mem_out;  
    end else if (alu_ready && (rd_alu != 0) && (rs1 == rd_alu)) begin  
        forwarded_data = alu_out;  
    end else if (mem_read && (rd_mem != 0) && (rs2 == rd_mem)) begin  
        forwarded_data = mem_out;  
    end else if (alu_ready && (rd_alu != 0) && (rs2 == rd_alu)) begin  
        forwarded_data = alu_out;  
    end  
end  
endmodule