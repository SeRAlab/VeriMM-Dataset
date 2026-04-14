module top_module(
    input clk_i,
    input rst_i,
    input [g_width-1:0] data_i,
    input push_i,
    input pull_i,
    output reg [g_width-1:0] data_o, // Changed to reg
    output full_o,
    output empty_o
);parameter g_width = 32;

    reg [g_width-1:0] mem;
    reg full;
    reg empty;

    always @(posedge clk_i or negedge rst_i) begin
        if (!rst_i) begin
            mem <= 0;
            empty <= 1;
            full <= 0;
            data_o <= 0; // Initialize data_o on reset
        end
        else begin
            if (push_i && !full) begin
                mem <= data_i;
                full <= 1;
                empty <= 0;
            end
            else if (pull_i && !empty) begin
                data_o <= mem;
                full <= 0;
                empty <= 1;
            end
        end
    end

    assign full_o = full;
    assign empty_o = empty;

endmodule