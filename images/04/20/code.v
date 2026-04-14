module pitch_detection (
    input clk,
    input reset,
    input sample,
    output reg [3:0] pitch
);
    reg [3:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            pitch <= 0;
        end else if (sample) begin
            count <= count + 1;
        end else begin
            pitch <= count;
            count <= 0;
        end
    end
endmodule