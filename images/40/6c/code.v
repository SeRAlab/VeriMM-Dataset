module wifi_controller (
    input clk,
    input rst,
    input req,
    output reg busy
);
    parameter N = 5; // Number of cycles to remain busy
    reg [2:0] count; // 3-bit counter to count cycles

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            busy <= 0;
            count <= 0;
        end else if (req && !busy) begin
            busy <= 1;
            count <= 0;
        end else if (busy) begin
            if (count < N - 1) begin
                count <= count + 1;
            end else begin
                busy <= 0;
            end
        end
    end
endmodule