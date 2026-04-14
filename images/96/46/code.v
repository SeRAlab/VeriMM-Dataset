module top_module(
    input clk,
    input up_down,
    input load_up,
    input load_down,
    input reset,
    output reg [7:0] count
);reg [3:0] up_count;
reg [3:0] down_count;

always @(posedge clk) begin
    if (reset) begin
        up_count <= 4'b0000;
        down_count <= 4'b1111;
        count <= 8'b00000000;
    end else begin
        if (load_up) begin
            up_count <= count[3:0];
        end
        if (load_down) begin
            down_count <= count[3:0];
        end
        if (up_down) begin
            if (up_count == 4'b1111) begin
                up_count <= 4'b0000;
            end else begin
                up_count <= up_count + 1;
            end
        end else begin
            if (down_count == 4'b0000) begin
                down_count <= 4'b1111;
            end else begin
                down_count <= down_count - 1;
            end
        end
        count <= up_count + down_count;
    end
end

endmodule