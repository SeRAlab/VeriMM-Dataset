module top_module(
    RegOut,   
    CA_reg_set, 
    RegInit,  
    Reset,    
    Clk,      
    CWR_pulse,
    CCSB,
    CA_reg,     
    CD_in_reg
);output [15:0] RegOut; 
    input  [6:0]  CA_reg_set;  
    input  [15:0] RegInit;
    input         Reset;
    input         Clk;
    input         CWR_pulse;
    input         CCSB;
    input  [7:0]  CA_reg;
    input  [15:0] CD_in_reg;
    
    reg [15:0] RegOut; 

    always @(posedge Reset, posedge Clk) begin
        if (Reset) begin
            RegOut <= RegInit;
        end else if (CWR_pulse && !CCSB && CA_reg[7:1] == CA_reg_set[6:0]) begin
            RegOut <= CD_in_reg;
        end
    end

endmodule