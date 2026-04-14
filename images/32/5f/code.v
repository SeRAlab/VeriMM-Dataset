module pulse_generator (
    input clk,
    input rst,
    input [3:0] N, // Width of pulse
    input [3:0] M, // Period of pulse
    output reg pulse
);
    reg [3:0] count;
    reg [3:0] pulse_count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            pulse_count <= 0;
            pulse <= 0;
        end else begin
            if (count < M) begin
                count <= count + 1;
            end else begin
                count <= 0;
            end
            
            if (count < N) begin
                pulse <= 1;
            end else begin
                pulse <= 0;
            end
        end
    end
endmodule