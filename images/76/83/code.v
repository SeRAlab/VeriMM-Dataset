module top_module(
    input clk,
    input en,
    input arst,
    input srst,
    input ld,
    input [7:0] d,
    output reg lz,       // Changed 'output lz' to 'output reg lz'
    output [7:0] z
);reg [7:0] stored_data;

    always @(posedge clk) begin
        if (en) begin
            if (arst) begin
                stored_data <= 8'b0;
                lz <= 0;
            end else if (srst) begin
                stored_data <= 8'b0;
                lz <= 0;
            end else begin
                if (ld) begin
                    stored_data <= d;
                    lz <= 1;
                end else begin
                    lz <= 1;
                end
            end
        end
    end

    assign z = stored_data;

endmodule