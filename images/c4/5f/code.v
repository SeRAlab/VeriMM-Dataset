module my_clock_gate (
    input CLK,
    input EN,
    input TE,
    output ENCLK
);

    wire n2;
    reg EN_reg;
    
    always @ (posedge CLK, posedge TE) begin
        if (TE) begin
            EN_reg <= 1'b0;
        end else begin
            EN_reg <= EN;
        end
    end
    
    assign n2 = EN_reg & CLK;
    assign ENCLK = n2;
    
endmodule