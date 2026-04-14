module bin2bcd(
    input       clk,
    input       rst_n,
    input [7:0] bin_in,
    output reg [11:0] bcd_out
);

    reg [7:0] shift_reg;
    reg [3:0] i;
    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            shift_reg <= 8'b0;
            bcd_out <= 12'b0;
            i <= 4'd0;
        end
        else begin
            shift_reg <= bin_in;
            bcd_out <= 12'b0;
            for (i = 0; i < 8; i = i + 1) begin
                if (bcd_out[3:0] >= 5)
                    bcd_out[3:0] <= bcd_out[3:0] + 3;
                if (bcd_out[7:4] >= 5)
                    bcd_out[7:4] <= bcd_out[7:4] + 3;
                if (bcd_out[11:8] >= 5)
                    bcd_out[11:8] <= bcd_out[11:8] + 3;
                
                bcd_out <= {bcd_out[10:0], shift_reg[7]};
                shift_reg <= {shift_reg[6:0], 1'b0};
            end
        end
    end

endmodule