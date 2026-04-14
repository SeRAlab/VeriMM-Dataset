module pcie_endpoint_controller (
    input wire clk,
    input wire reset,
    input wire cmd, // 1 for store, 0 for release
    input wire [7:0] data_in,
    output reg [7:0] data_out
);
    reg [7:0] stored_data;
    reg [3:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            stored_data <= 8'b0;
            count <= 4'b0;
            data_out <= 8'b0;
        end else begin
            if (cmd) begin
                stored_data <= data_in;
                count <= count + 1;
            end else if (count > 0) begin
                data_out <= stored_data;
                count <= count - 1;
            end
        end
    end
endmodule