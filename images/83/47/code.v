module top_module(
    input [3:0] data_in,
    input [1:0] control,
    output [3:0] data_out
);reg [3:0] stage1_out;
reg [3:0] stage2_out;

always @(data_in, control) begin
    case (control)
        2'b00: stage1_out <= {data_in[2:0], 1'b0}; // logical shift left
        2'b01: stage1_out <= {1'b0, data_in[3:1]}; // logical shift right
        2'b10: stage1_out <= {data_in[2:0], data_in[3]}; // arithmetic shift left
        2'b11: stage1_out <= {data_in[3], data_in[3:1]}; // arithmetic shift right
    endcase
end

always @(stage1_out) begin
    case (control)
        2'b00: stage2_out <= {stage1_out[1:0], data_in[3:2]}; // logical shift left
        2'b01: stage2_out <= {data_in[3], stage1_out[2:0]}; // logical shift right
        2'b10: stage2_out <= {stage1_out[1:0], stage1_out[3]}; // arithmetic shift left
        2'b11: stage2_out <= {stage1_out[3], stage1_out[2:0]}; // arithmetic shift right
    endcase
end

assign data_out = stage2_out;

endmodule