module up_down_counter(
    input               clk     , 
    input               rst     ,
    input               up_down ,

    output reg  [2:0]   count
);

// Counter operation
always @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 3'd0;
    end else begin
        if (up_down) begin
            count <= count + 1;
        end else begin
            count <= count - 1;
        end
    end
end

endmodule