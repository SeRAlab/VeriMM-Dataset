module down_counter (
    input wire clk,
    input wire rst,
    input wire load,
    input wire [3:0] init_value,
    output reg [3:0] count
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= init_value;
        end else if (load) begin
            count <= init_value;
        end else begin
            count <= count - 1;
        end
    end
endmodule