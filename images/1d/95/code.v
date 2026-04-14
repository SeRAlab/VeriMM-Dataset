module pulse_generator (
    input wire clk,
    input wire rst,
    input wire [3:0] high_duration,
    input wire [3:0] low_duration,
    output reg pulse
);

    reg [3:0] count;
    reg state; // 0 for low, 1 for high

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            pulse <= 0;
            state <= 0; // start with low
        end else begin
            if (count < (state ? high_duration : low_duration)) begin
                count <= count + 1;
                pulse <= state; // output pulse state
            end else begin
                count <= 0;
                state <= ~state; // toggle state
                pulse <= ~state; // output the new state
            end
        end
    end
endmodule