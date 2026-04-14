module clock_control_altclkctrl_0 (
    input ena,
    input inclk,
    output reg outclk
);

reg inclk_reg;
reg [31:0] counter;

always @ (posedge inclk or negedge ena) begin
    if (!ena) begin
        outclk <= 1'b0;
        counter <= 0;
    end
    else begin
        inclk_reg <= inclk;
        counter <= counter + 1;
        if (counter == 1) begin
            outclk <= inclk_reg;
        end
        else if (counter == 2) begin
            outclk <= ~inclk_reg;
            counter <= 0;
        end
    end
end

endmodule