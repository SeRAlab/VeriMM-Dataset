module top_module(
    input clk,
    input rst,
    output reg [31:0] count,
    output reg max_reached
);reg [31:0] max_count = 32'hFFFFFFFF; // maximum count value

always @(posedge clk) begin
    if (rst) begin
        count <= 0;
        max_reached <= 0;
    end
    else begin
        if (count == max_count) begin
            max_reached <= 1;
        end
        else begin
            count <= count + 1;
            max_reached <= 0;
        end
    end
end

endmodule