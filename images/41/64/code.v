module square_wave_gen(
    input       clk,
    input       rst_n,
    output reg  square_wave_out
);

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            square_wave_out <= 1'b0;
        end
        else begin
            square_wave_out <= ~square_wave_out;
        end
    end

endmodule