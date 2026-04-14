module barrel_shifter (
    input [3:0] data_in,
    input [1:0] shift_amt,
    input dir, // 0 for left, 1 for right
    output reg [3:0] data_out
);
    
    always @(*) begin
        case ({dir, shift_amt})
            3'b000: data_out = data_in; // 0 positions left
            3'b001: data_out = dir ? {1'b0, data_in[3:1]} : {data_in[2:0], 1'b0}; // 1 position
            3'b010: data_out = dir ? {2'b00, data_in[3:2]} : {data_in[1:0], 2'b00}; // 2 positions
            3'b011: data_out = dir ? {3'b000, data_in[3]} : {data_in[0], 3'b000}; // 3 positions
            default: data_out = 4'b0000; // Default case
        endcase
    end
endmodule