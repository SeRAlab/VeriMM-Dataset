module top_module(
    input CLK,
    input ready_downstream,
    output reg ready,
    input reset,
    input [64:0] process_input,
    output reg [64:0] process_output
);reg too_soon = process_input[64];
reg [31:0] output_count = 0;

always @(posedge CLK) begin
    if (reset) begin
        ready <= 1'b0;
        output_count <= 0;
        process_output <= 0;
    end else if (too_soon) begin
        ready <= 1'b0;
    end else if (ready_downstream && output_count < 76800) begin
        ready <= 1'b1;
        output_count <= output_count + 1;
        process_output <= ~reset;
    end else begin
        ready <= 1'b1;
        output_count <= output_count + 1;
        process_output <= {1'b1, process_input[63:0]};
    end
end

endmodule