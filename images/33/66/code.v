module pitch_detector (
    input clk,
    input rst,
    input [11:0] frequency_in, // 12-bit input frequency
    output reg match // Output signal to indicate if the pitch is detected
);
    parameter TARGET_FREQ = 12'd440;
    parameter TOLERANCE = 12'd10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            match <= 0;
        end else begin
            if ((frequency_in >= TARGET_FREQ - TOLERANCE) && (frequency_in <= TARGET_FREQ + TOLERANCE)) begin
                match <= 1;
            end else begin
                match <= 0;
            end
        end
    end
endmodule