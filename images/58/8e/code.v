module square_wave (
    input clk,
    input reset,
    output reg wave_out
);

    reg [1:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 2'b00;
            wave_out <= 0;
        end else begin
            count <= count + 1;
            wave_out <= (count == 2'b10) ? ~wave_out : wave_out;
        end
    end
endmodule