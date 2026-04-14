module up_down_counter_3bit(
    input                 clk,
    input                 rst,
    input                 en,
    input                 up_down,
    
    output reg [2:0]      count
);

// Up/down counter implementation
always @(posedge clk) begin
    if (rst)
        count <= 3'd0;
    else if (en) begin
        if (up_down)
            count <= count + 3'd1;
        else
            count <= count - 3'd1;
    end
end

endmodule