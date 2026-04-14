module top_module(
    input clk,
    input reset,
    input enable,
    input up_down,
    output reg [1:0] count,
    output reg overflow
);always @(posedge clk) begin
        if (!reset) begin
            count <= 2'b00;
            overflow <= 0;
        end else if (enable) begin
            if (up_down) begin
                if (count == 2'b11) begin
                    count <= 2'b00;
                    overflow <= 1;
                end else begin
                    count <= count + 2'b01;
                    overflow <= 0;
                end
            end else begin
                if (count == 2'b00) begin
                    count <= 2'b11;
                    overflow <= 1;
                end else begin
                    count <= count - 2'b01;
                    overflow <= 0;
                end
            end
        end
    end

endmodule