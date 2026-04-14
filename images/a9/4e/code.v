module top_module(
    input wire       clk,   
    input wire[4:0]  rs1_i, 
    input wire[4:0]  rs2_i, 
    input wire[4:0]  rd_i,  
    input wire       w_en,  
    input wire[31:0] w_data, 
    
    output wire[31:0] rs1_o, 
    output wire[31:0] rs2_o  
    );reg[31:0] gpr[31:0]; 
    
    assign rs1_o = (rs1_i == 0) ? 32'h00000000 : gpr[rs1_i]; 
    assign rs2_o = (rs2_i == 0) ? 32'h00000000 : gpr[rs2_i]; 
    
    always @ (posedge clk) begin
        if (w_en) begin
            gpr[rd_i] <= w_data; 
        end
    end
endmodule