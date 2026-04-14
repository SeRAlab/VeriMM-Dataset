module top_module(
    input clk,
    input reset,
    input enable,
    input control,
    output reg max_min, // Changed to output reg
    output reg [3:0] count
);always @(posedge clk) begin
        if (reset) begin
            count <= 4'b0;
            max_min <= 1'b0;
        end
        else if (enable) begin
            if (control) begin
                if (count == 4'b1111) begin
                    count <= 4'b0;
                    max_min <= 1'b1;
                end
                else begin
                    count <= count + 1;
                    max_min <= 1'b0;
                end
            end
            else begin
                if (count == 4'b0000) begin
                    count <= 4'b1111;
                    max_min <= 1'b1;
                end
                else begin
                    count <= count - 1;
                    max_min <= 1'b0;
                end
            end
        end
    end

endmodule