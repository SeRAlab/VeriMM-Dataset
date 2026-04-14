module top_module(
    input clk,
    input reset,
    input load,
    input up_down,
    output reg [2:0] count,
    output reg overflow,
    output reg underflow
);always @(posedge clk or negedge reset) begin
        if (reset == 0) begin
            count <= 3'b0;
            overflow <= 1'b0;
            underflow <= 1'b0;
        end
        else if (load == 1) begin
            count <= count;
            overflow <= 1'b0;
            underflow <= 1'b0;
        end
        else if (up_down == 1) begin
            if (count == 3'b111) begin
                count <= 3'b000;
                overflow <= 1'b1;
                underflow <= 1'b0;
            end
            else begin
                count <= count + 1;
                overflow <= 1'b0;
                underflow <= 1'b0;
            end
        end
        else begin
            if (count == 3'b000) begin
                count <= 3'b111;
                overflow <= 1'b0;
                underflow <= 1'b1;
            end
            else begin
                count <= count - 1;
                overflow <= 1'b0;
                underflow <= 1'b0;
            end
        end
    end

endmodule