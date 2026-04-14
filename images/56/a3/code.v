module top_module(
    input clk,
    input en,
    input arst,
    input srst,
    input ld,
    input [width-1:0] d,
    output reg lz,                 // Change to output reg
    output reg [width-1:0] z       // Change to output reg
);parameter integer rscid = 1;
    parameter integer width = 8;
    parameter ph_en = 1'b1;
    parameter ph_arst = 1'b1;
    parameter ph_srst = 1'b1;

    always @ (posedge clk) begin
        if (arst == 1'b0) begin
            lz <= 1'b0;
            z <= {width{1'b0}};
        end else if (srst == ph_srst) begin
            lz <= 1'b0;
            z <= {width{1'b0}};
        end else if (en == ph_en) begin
            if (ld == 1'b1) begin
                lz <= 1'b0;
                z <= ~d;
            end else begin
                lz <= (z == {width{1'b0}});
                z <= z - d;
            end
        end
    end

endmodule