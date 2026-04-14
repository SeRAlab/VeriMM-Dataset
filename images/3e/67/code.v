module down_counter (
    input wire clk,
    input wire rst_n,
    input wire load,
    input wire [4:0] init_value,
    output reg [4:0] count
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 5'b00000; // Reset count to zero
        end else if (load) begin
            count <= init_value; // Load new initial value
        end else if (count > 0) begin
            count <= count - 1; // Decrement count
        end
    end
endmodule