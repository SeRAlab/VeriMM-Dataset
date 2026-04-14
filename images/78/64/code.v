module top_module(
    output reg Q,
    input  CLK,
    input  D,
    input  SCD,
    input  SCE,
    input  SET_B,
    input  VPWR,
    input  VGND,
    input  VPB,
    input  VNB
);reg Q_reg;
    always @(posedge CLK or negedge SET_B) begin
        if (!SET_B) begin
            Q_reg <= 1'b1; // Active low asynchronous set
        end else if (SCD && SCE) begin
            Q_reg <= 1'b0;
        end else if (SCD) begin
            Q_reg <= 1'b0;
        end else if (SCE) begin
            Q_reg <= D;
        end 
    end

    assign Q = Q_reg;

endmodule