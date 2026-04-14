module top_module(
    clk,
    fixed_num,
    round,
    overflow
    );parameter num_width = 42;
    parameter fixed_pos = 16;
    parameter res_width = 12;

    input clk;
    input signed [num_width - 1 : 0] fixed_num;
    output reg signed [res_width : 0] round;
    output reg overflow;

    reg signed [num_width - 1 : 0] num_orig;
    reg num_orig_sflag, num_orig_rflag, reg_overflow;
    reg signed [res_width : 0] num_comp;

    always @(posedge clk) begin
        // Update num_orig with correct concatenation width
        if (fixed_num[num_width - 1] == 0) begin
            num_orig <= fixed_num;
        end else begin
            num_orig <= {fixed_num[num_width - 1], 
                          {num_width - 1{1'b1}} - fixed_num[num_width - 2 : 0]};
        end

        // Update num_comp with correct concatenation width
        if (num_orig[num_width - 1] == 0) begin
            num_comp <= {num_orig[num_width - 1], num_orig[res_width + fixed_pos - 1 : fixed_pos]};
        end else begin
            num_comp <= {num_orig[num_width - 1], 
                          {num_width - res_width - fixed_pos{1'b1}} - num_orig[res_width + fixed_pos - 1 : fixed_pos]};
        end
        
        // Check for overflow
        reg_overflow <= (num_orig[num_width - 2 : res_width + fixed_pos] != 0);
        overflow <= reg_overflow;

        num_orig_sflag <= num_orig[num_width - 1];
        num_orig_rflag <= num_orig[fixed_pos - 1];

        // Round logic
        case(num_orig_sflag)
            0 : round <= (num_orig_rflag == 0) ? num_comp : num_comp + 1;
            1 : round <= (num_orig_rflag == 0) ? num_comp : num_comp - 1;
            default : round <= round; // retain previous value
        endcase
    end

endmodule