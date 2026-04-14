module reset_controller (
    input wire clk,
    input wire rst_n,
    input wire enable,
    output reg reset_out
);
    reg [3:0] count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reset_out <= 1'b1;
            count <= 4'b0000;
        end else if (enable) begin
            if (count < 4'b1111) begin
                count <= count + 1;
            end else begin
                reset_out <= 1'b0;
            end
        end else begin
            reset_out <= 1'b1; // Maintain reset when not enabled
        end
    end
endmodule