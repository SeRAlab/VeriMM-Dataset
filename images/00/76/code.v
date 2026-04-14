module barrel_shifter (
    input [1:0] in_data,
    input dir,
    output reg [1:0] out_data
);
    always @(*) begin
        if (dir == 1'b0) begin // Left shift
            out_data = {in_data[0], 1'b0}; // Shift left and fill with 0
        end else begin // Right shift
            out_data = {1'b0, in_data[1]}; // Shift right and fill with 0
        end
    end
endmodule