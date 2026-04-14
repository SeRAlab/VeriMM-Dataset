module loadable_counter(
    input wire clk,
    input wire rst,
    input wire load,
    input wire [15:0] load_value,
    output reg [15:0] count
);

    always @(posedge clk) begin
        if (rst) begin
            count <= 16'b0;
        end else if (load) begin
            count <= load_value;
        end else begin
            count <= count + 1;
        end
    end
endmodule