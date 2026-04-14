module BLOCK2A ( PIN2, GIN1, GIN2, PHI, GOUT );
input  PIN2;
input  GIN1;
input  GIN2;
input  PHI;
output GOUT;

reg GOUT_reg;

always @(posedge PHI) begin
    if (GIN2 == 1'b1) begin
        GOUT_reg <= 1'b0;
    end else begin
        if ((PIN2 == 1'b0 && GIN1 == 1'b1) || (PIN2 == 1'b1 && GIN1 == 1'b0)) begin
            GOUT_reg <= 1'b1;
        end else begin
            GOUT_reg <= 1'b0;
        end
    end
end

assign GOUT = GOUT_reg;

endmodule