module sr_flip_flop (
    input wire S,
    input wire R,
    input wire clk,
    input wire rst,
    output reg Q,
    output reg Qn
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            Q <= 0;
            Qn <= 1;
        end else begin
            if (S && !R) begin
                Q <= 1;
                Qn <= 0;
            end else if (!S && R) begin
                Q <= 0;
                Qn <= 1;
            end // Indeterminate state is not specified in behavior
        end
    end
endmodule