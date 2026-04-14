module sync_up_counter_load(
    input clk,
    input load_en,
    input [9:0] load_val,
    output reg [9:0] q
    );

    always @(posedge clk) begin
        if (load_en) begin
            q <= load_val;
        end else begin
            q <= q + 1;
        end
    end
endmodule