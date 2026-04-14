module counter (
    input wire clk,
    input wire rst,
    input wire enable,
    input wire up,
    input wire down,
    input wire load,
    input wire [1:0] load_value,
    output reg [1:0] count
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 2'b00;
        end else if (enable) begin
            if (load) begin
                count <= load_value;
            end else if (up) begin
                count <= count + 1;
            end else if (down) begin
                count <= count - 1;
            end
        end
    end
endmodule