module binary_down_counter(
    input                 clk,
    input                 rst,
    input                 enable,
    input                 load,
    input       [2:0]     load_val,
    output   reg [2:0]    count
);

// Counting logic
always @(posedge clk) begin
    if (rst) begin
        count <= 3'd7;
    end else if (load) begin
        count <= load_val;
    end else if (enable) begin
        if (count == 3'd0) begin
            count <= 3'd7;
        end else begin
            count <= count - 1;
        end
    end
end

endmodule