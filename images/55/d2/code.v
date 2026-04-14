module sync_up_counter_6bit (
    input wire clk,
    input wire rst,
    input wire en,
    input wire load,
    input wire [5:0] load_value,
    output reg [5:0] count
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 6'b000000;
        end else if (load) begin
            count <= load_value;
        end else if (en) begin
            count <= count + 1;
        end
    end

endmodule