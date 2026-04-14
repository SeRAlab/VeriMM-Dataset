module top_module(
    input wire [31:0] PCF,JalrTarget, BranchTarget, JalTarget,
    input wire BranchE,JalD,JalrE,
    input wire PCF_SEL,
    input wire [31:0] PCF_PRE,
    input wire [31:0] PCE,
    input wire BTB_FILL,
    input wire BTB_PREFAIL,
    output reg [31:0] PC_In
    );wire [31:0] PC_raw;
assign PC_raw = PCF_SEL?PCF_PRE:PCF + 4;

always @(*) 
begin
if(BranchE)
begin
    if(BTB_FILL)begin
        PC_In <= BranchTarget;
    end else begin
        PC_In <= PCF + 4;
    end
end
else if(BTB_PREFAIL)
begin
    PC_In <= PCE + 4;
end
else if(JalrE)    
begin
    PC_In <= JalrTarget;
end
else if(JalD)
begin
    PC_In <= JalTarget;
end
else
begin
    PC_In <= PC_raw;
end
end
    
endmodule