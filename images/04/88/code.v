module up_down_counter (
    input wire clk,
    input wire reset,
    input wire up_down, // 1 for up, 0 for down
    output reg [1:0] count
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 2'b00; // Reset counter to 0
        end else begin
            if (up_down) begin
                if (count == 2'b11) begin
                    count <= 2'b00; // Roll over to 0
                end else begin
                    count <= count + 1; // Increment counter
                end
            end else begin
                if (count == 2'b00) begin
                    count <= 2'b11; // Roll over to 3
                end else begin
                    count <= count - 1; // Decrement counter
                end
            end
        end
    end
endmodule