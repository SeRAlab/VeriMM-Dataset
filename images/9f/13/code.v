module top_module(
    input  D   ,
    output Q   ,
    input  CLK ,
    input  VPB ,
    input  VPWR,
    input  VGND,
    input  VNB
);// Declare any necessary wires or registers
    reg Q_reg;
    
    // Always block for clocking
    always @(posedge CLK) begin
        Q_reg <= D;
    end
    
    // Assign output Q to Q_reg
    assign Q = Q_reg;
    
endmodule