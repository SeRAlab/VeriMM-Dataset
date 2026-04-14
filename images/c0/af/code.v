module bitsplit(
    input   clk,
    input   bit1_i,
    input   bit2_i,
    output  largebit_o,
    output  smallbit_o,
    input   swap_i,
    output  swap_o,
    input   run_i,
    output  run_o
    );
    reg     r_bit1;
    reg     r_bit2;
    reg     r_small_bit;
    reg     r_large_bit;
    reg     r_compare_result;
    reg     r_freeze_compare;
    reg [0:1]   r_swap;
    reg [0:1]   r_run;
    wire    w_different_bits;
    always @(posedge clk)
        begin
            if (~run_i) begin
                r_freeze_compare <= 0;      end
            else if (w_different_bits) begin
                r_freeze_compare <= 1;      end
        end
    always @(posedge clk)
        begin
            if (~run_i) begin
                r_compare_result <= 0;      end
            else if (~r_freeze_compare) begin
                if (bit1_i & ~bit2_i)   begin
                    r_compare_result <= 1;  end
                else begin
                    r_compare_result <= 0;  end                
                end
        end
    always @(posedge clk)
        begin
            r_bit1 <= bit1_i;
            r_bit2 <= bit2_i;
            if (~r_compare_result) begin
                r_small_bit <= r_bit1;
                r_large_bit <= r_bit2;   end
            else begin
                r_small_bit <= r_bit2;
                r_large_bit <= r_bit1;   end
        end
    always @(posedge clk)
        begin
            r_swap[0] <= swap_i;
            r_swap[1] <= r_swap[0] | r_compare_result;
        end
    always @(posedge clk)
        begin
            r_run[0] <= run_i;
            r_run[1] <= r_run[0];
        end
    assign w_different_bits = bit1_i ^ bit2_i;
    assign largebit_o = r_large_bit;
    assign smallbit_o = r_small_bit;
    assign swap_o = r_swap[1];
    assign run_o = r_run[1];
endmodule