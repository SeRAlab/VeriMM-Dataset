module timer (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [15:0] max_value,
    output reg [15:0] current_count
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_count <= 16'b0;
        end else if (start) begin
            if (current_count < max_value) begin
                current_count <= current_count + 1;
            end else begin
                current_count <= 16'b0; // Wrap around
            end
        end
    end
endmodule