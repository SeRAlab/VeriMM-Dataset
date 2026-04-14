module binary_counter(
    input                 clk,
    input                 rst,
    input                 en,
    output  reg [2:0]     count
);

// Counter logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 3'd0;
    end else if (en) begin
        count <= count + 1;
    end
end

endmodule