module sync_down_counter_32bit (
    input wire clk,
    input wire rst,
    input wire en,
    input wire load,
    input wire [31:0] load_value,
    output reg [31:0] count
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 32'b0;
        end else if (load) begin
            count <= load_value;
        end else if (en) begin
            count <= count - 1;
        end
    end

endmodule