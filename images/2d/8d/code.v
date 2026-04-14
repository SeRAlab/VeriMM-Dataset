module dram_cell (
    input wire D,
    input wire WE,
    input wire RST,
    output reg Q
);
    always @(posedge WE or posedge RST) begin
        if (RST) begin
            Q <= 1'b0;
        end else begin
            Q <= D;
        end
    end
endmodule