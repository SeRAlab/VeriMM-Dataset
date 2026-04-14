module top_module(
    input clk,
    input rst,
    output reg [3:0] count,
    output reg done
);// Synchronous reset
always @(posedge clk) begin
    if (rst) begin
        count <= 4'b0;
        done <= 1'b0;
    end
    else begin
        if (count == 4'b1001) begin
            count <= 4'b0;
            done <= 1'b1;
        end
        else begin
            count <= count + 1;
            done <= 1'b0;
        end
    end
end

// Combinational logic to check if the counter is equal to 9
always @(*) begin
    if (count == 4'b1001)
        done <= 1'b1;
    else
        done <= 1'b0;
end

endmodule