module top_module(
    input clk,            // Added clk input
    input reset,
    input [31:0] inData,
    input inValid,
    output [31:0] outData,
    output outValid,
    output done
);reg [31:0] state;
reg [31:0] next_outData;
reg outValid_reg;
reg done_reg;
reg [1:0] wait_count;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        next_outData <= 0;
        outValid_reg <= 0;
        done_reg <= 0;
        wait_count <= 0;
    end else begin
        case (state)
            0: begin
                if (inValid) begin
                    next_outData <= inData + 1;
                    outValid_reg <= 1;
                    state <= 1;
                end
            end
            1: begin
                if (wait_count == 2) begin
                    done_reg <= 1;
                    state <= 0;
                end else begin
                    wait_count <= wait_count + 1;
                end
            end
        endcase
    end
end

assign outData = next_outData;
assign outValid = outValid_reg;
assign done = done_reg;

endmodule