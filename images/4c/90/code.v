module top_module(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    input [255:0] in,
    input sel,
    output reg [99:0] rotator_output,
    output reg out
);reg [99:0] rotator_reg;

// Always block to load data or perform rotation
always @(posedge clk) begin
    if (load) begin
        rotator_reg <= data;
    end else begin
        if (ena[0]) begin
            if (ena[1]) begin
                rotator_reg <= {rotator_reg[98:0], rotator_reg[99]}; // Right rotation
            end else begin
                rotator_reg <= {rotator_reg[0], rotator_reg[99:1]}; // Left rotation
            end
        end else if (ena[1]) begin
            rotator_reg <= {rotator_reg[0], rotator_reg[99:1]}; // Left rotation if only ena[1] is asserted
        end
    end
end

assign rotator_output = rotator_reg;

// Always block for output logic
always @(sel or rotator_output or in) begin
    if (sel) begin
        out <= in[255];
    end else begin
        out <= &({rotator_output, in[255]});
    end
end

endmodule