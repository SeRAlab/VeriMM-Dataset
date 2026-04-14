module down_counter (
    input clk,
    input reset,
    input load,
    input [7:0] load_value,
    output reg [7:0] count
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 8'd255; // Default reset value
        end else if (load) begin
            count <= load_value;
        end else if (count > 0) begin
            count <= count - 1;
        end
    end
endmodule