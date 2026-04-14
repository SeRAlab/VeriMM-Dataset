module dram_cell (
    input wire [7:0] data,
    input wire we,
    input wire rst,
    output reg [7:0] q
);
    always @(posedge rst or posedge we) begin
        if (rst) begin
            q <= 8'b0;
        end else if (we) begin
            q <= data;
        end
    end
endmodule