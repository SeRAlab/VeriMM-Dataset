module up_down_counter(
    input clk,
    input reset,
    input up_down, // 1 for up, 0 for down
    input [3:0] start_value,
    input [3:0] max_value,
    input [3:0] min_value,
    output reg [3:0] count
);
    
    initial begin
        count = 4'b0000; // Initialize count
    end
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= start_value;
        end else begin
            if (up_down) begin
                if (count < max_value) begin
                    count <= count + 1;
                end
            end else begin
                if (count > min_value) begin
                    count <= count - 1;
                end
            end
        end
    end
endmodule