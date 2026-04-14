module cordic_vectoring (
    input clk,
    input reset,
    input enable,
    input signed [3:0] x_in,
    input signed [3:0] y_in,
    output reg done,
    output reg [3:0] theta_out
);
    reg [3:0] x;
    reg [3:0] y;
    reg [2:0] stage;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            stage <= 0;
            done <= 0;
            theta_out <= 0;
        end else if (enable) begin
            if (stage < 4) begin
                if (y < 0) begin
                    x <= x + (y >> stage);
                    y <= y + (x >> stage);
                    theta_out <= theta_out - (1 << stage);
                end else begin
                    x <= x - (y >> stage);
                    y <= y - (x >> stage);
                    theta_out <= theta_out + (1 << stage);
                end
                stage <= stage + 1;
            end else begin
                done <= 1;
            end
        end
    end
endmodule