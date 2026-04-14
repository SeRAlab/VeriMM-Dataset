module top_module(
    input clk,
    input output_enable,
    input [23:0] tone_switch_period,
    input volume,
    output square_wave_out,
    output [31:0] _counter
);reg [31:0] counter = 32'h0000_0001; 
    reg square_out = 0;
    reg pwm_out = 0;

    assign square_wave_out = square_out && pwm_out;
    assign _counter = counter;

    always @(posedge clk) begin
        
        if (counter <= 32'h0000_0001) begin
            if (output_enable == 1'b1) begin
                square_out <= ~square_out;
            end else begin
                square_out <= 0;
            end
            
            
            counter[23:0] <= tone_switch_period;
            
        end else begin
            
            counter <= counter - 1;
        end
        
        if (volume == 1) begin
            pwm_out <= counter[2];
        end else begin
            pwm_out <= counter[2] && counter[1];
        end
    end
endmodule