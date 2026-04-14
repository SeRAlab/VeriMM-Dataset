module top_module(
    input signed [20:0] charge_in,
    input signed [14:0] signal_in,
    input delay_en,
    input clk,
    input store_strb,
    output reg [12:0] DSPout,
    input bunch_strb
);reg signed [47:0] DSPout_temp, DSPout_temp2, DSPout_temp4, DSPout_temp5;
reg signed [47:0] delayed = 48'b0;
reg signed [47:0] delayed_a = 48'b0;
reg signed [47:0] delayed_b = 48'b0;
reg signed [12:0] DSPout_temp6;
reg [3:0] j = 0;

always @ (posedge clk) begin
    if (delay_en == 1 & j < 14) begin
        DSPout_temp <= (charge_in * signal_in);
        DSPout_temp2 <= DSPout_temp;
        DSPout_temp4 <= DSPout_temp2;
        DSPout_temp5 <= DSPout_temp4 + delayed;
        DSPout_temp6 <= DSPout_temp5[24:12];
        DSPout <= DSPout_temp6;
    end
    else begin
        DSPout_temp <= (charge_in * signal_in);
        DSPout_temp2 <= DSPout_temp;
        DSPout_temp4 <= DSPout_temp2;
        DSPout_temp5 <= DSPout_temp4;
        DSPout_temp6 <= DSPout_temp5[24:12];
        DSPout <= DSPout_temp6;
    end
end

always @ (posedge clk) begin
    if (~bunch_strb) begin
        if (j == 14) j <= 0;
        else j <= j + 1;
    end
end

always @ (posedge clk) begin
    delayed <= delayed_a;
    delayed_a <= delayed_b;
    if (~store_strb) begin
        delayed_b <= 0;
    end
    else if (j == 1) begin
        delayed_b <= DSPout_temp5;
    end
    else begin
        delayed_b <= delayed_b;
    end
end

endmodule