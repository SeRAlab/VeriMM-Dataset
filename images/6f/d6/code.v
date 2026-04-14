module binary_counter(
    input               clk  , 
    input               rst  ,

    output reg  [3:0]   count
);

// Counter operation
always @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 4'd0;
    end else begin
        count <= count + 1;
    end
end

endmodule