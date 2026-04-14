module top_module(
    input a, 
    input b,
    input c,
    input reset,
    input clk, // Added clk input to resolve compilation errors
    output wire out_assign,
    output reg out_alwaysblock
);reg [2:0] pipeline_reg; // Change size to hold 3 bits for inputs a, b, and c

always @(posedge clk) begin
    if(reset) begin
        pipeline_reg <= 3'b0; // reset the pipeline register to 0
        out_alwaysblock <= 0; // reset the output to 0
    end
    else begin
        pipeline_reg <= {c, pipeline_reg[2:1]}; // shift the pipeline register
        case(pipeline_reg)
            3'b000, 3'b001, 3'b010: out_alwaysblock <= 0; // if 0 or 1 inputs are high, output is low
            3'b011, 3'b101, 3'b110: out_alwaysblock <= 1; // if 2 inputs are high, output is high
            3'b111: out_alwaysblock <= 0; // if all 3 inputs are high, output is low
        endcase
    end
end

assign out_assign = out_alwaysblock; // assign the output value to the output wire

endmodule