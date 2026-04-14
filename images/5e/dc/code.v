module binary_counter(
    input                 clk,
    input                 rst,
    input                 enable,
    
    output reg [3:0]      count
);

// Counter implementation
always @(posedge clk) begin
    if (rst) begin
        count <= 4'd0;
    end
    else if (enable) begin
        count <= count + 1;
    end
end

endmodule