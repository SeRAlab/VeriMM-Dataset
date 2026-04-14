module top_module(
    output Q,
    input  CLK,
    input  D,
    input  DE,
    input  VPWR,
    input  VGND,
    input  VPB,
    input  VNB
);reg Q_reg;
    
    always @ (posedge CLK) begin
        if (DE) begin
            Q_reg <= D;
        end
    end

    assign Q = Q_reg;  // Only output the registered value

endmodule