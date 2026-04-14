module top_module( data, ld_reg, dr, sr1, sr2, clk, rst, sr1_out, sr2_out);input wire [15:0] data; 
    input wire ld_reg; 
    input wire [2:0] dr; 
    input wire [2:0] sr1; 
    input wire [2:0] sr2; 
    input wire clk; 
    input wire rst; 
    output wire sr1_out; 
    output wire sr2_out; 

    
    reg [15:0]regs[0:7];

    
    
    
    
    
    assign sr1_out = regs[sr1];
    assign sr2_out = regs[sr2];

    always @(posedge clk or posedge rst) begin
        if (rst) begin 
            regs[0] <= 0; regs[1] <= 0; regs[2] <= 0; regs[3] <= 0;
            regs[4] <= 0; regs[5] <= 0; regs[6] <= 0; regs[7] <= 0;
        end
        else if (ld_reg) regs[dr] <= data;
    end

endmodule