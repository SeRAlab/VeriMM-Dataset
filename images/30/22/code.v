module checksum_calculator (
    input wire clk,
    input wire valid,
    input wire [4:0] data_in,
    output reg [3:0] checksum
);
    
    always @(posedge clk) begin
        if (valid) begin
            checksum <= (checksum + data_in) % 16;
        end
    end

endmodule