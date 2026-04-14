module flash_memory (
    input wire clk,
    input wire ctrl,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);
    always @(posedge clk) begin
        if (ctrl) begin
            data_out <= data_in;
        end
    end
endmodule