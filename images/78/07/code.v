module up_down_counter(
    input                 clk,
    input                 rst,
    input                 en,
    input                 mode,
    output  reg [15:0]    count
);

// Counter logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 16'd0;
    end else if (en) begin
        if (mode) begin
            count <= count + 1;
        end else begin
            count <= count - 1;
        end
    end
end

endmodule