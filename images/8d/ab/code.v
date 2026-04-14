module top_module(
    clk,
    reset_n,
    ast_sink_data,
    ast_sink_valid,
    ast_source_ready,
    ast_sink_error,
    ast_source_data,
    ast_sink_ready,
    ast_source_valid,
    ast_source_error
);input clk;
    input reset_n;
    input [14:0] ast_sink_data;
    input ast_sink_valid;
    input ast_source_ready;
    input [1:0] ast_sink_error;
    output reg [30:0] ast_source_data; // Change to reg
    output reg ast_sink_ready;         // Change to reg
    output reg ast_source_valid;       // Change to reg
    output reg [1:0] ast_source_error; // Change to reg

    reg [14:0] sink_reg;
    reg [1:0] error_reg;
    reg [30:0] source_reg;
    reg source_valid_reg;
    reg sink_ready_reg;
    reg [1:0] source_error_reg;

    always @(posedge clk) begin
        if (!reset_n) begin
            sink_reg <= 15'b0;
            error_reg <= 2'b0;
            sink_ready_reg <= 1'b1;
            source_valid_reg <= 1'b0;
        end else if (ast_sink_valid) begin
            sink_reg <= ast_sink_data;
            error_reg <= ast_sink_error;
            sink_ready_reg <= 1'b0;
        end else if (ast_source_ready && source_valid_reg) begin
            source_valid_reg <= 1'b0;
            sink_ready_reg <= 1'b1;
        end
    end

    always @(posedge clk) begin
        if (ast_source_ready && source_valid_reg) begin
            // No need to set source_valid_reg here again
            // as it's already being reset in the first always block.
        end else if (source_valid_reg && !ast_source_ready) begin
            // Output the data and error when ready
            ast_source_data <= source_reg;   // Valid assignment now
            ast_source_error <= source_error_reg; // Valid assignment now
        end
    end

    always @* begin
        source_reg = {16'b0, sink_reg, error_reg};
        source_error_reg = error_reg;

        if (ast_source_ready && sink_ready_reg && ast_sink_valid) begin
            source_valid_reg = 1;
        end else begin
            source_valid_reg = 0;
        end
    end

    // Assign outputs
    assign ast_sink_ready = sink_ready_reg;
    assign ast_source_valid = source_valid_reg;

endmodule