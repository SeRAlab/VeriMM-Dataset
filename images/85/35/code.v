module sync_counter_8bit (
    input wire clk,
    input wire rst,
    input wire load,
    input wire [7:0] data_in,
    output reg [7:0] count
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 8'b0;
        end else if (load) begin
            count <= data_in;
        end else begin
            count <= count + 1;
        end
    end

endmodule