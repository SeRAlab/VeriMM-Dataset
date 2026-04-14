module top_module(
    input clock,
    input resetn,
    input valid_in,
    input stall_in,
    input start,
    input [31:0] workgroup_size,
    output reg valid_out, // Changed to reg
    output reg stall_out   // Changed to reg
);// Branch node
    reg [1:0] branch_state;
    always @(posedge clock or negedge resetn) begin
        if (~resetn) begin
            branch_state <= 2'b00;
            valid_out <= 1'b0;   // Initialize valid_out
            stall_out <= 1'b0;   // Initialize stall_out
        end else begin
            case (branch_state)
                2'b00: begin // Idle state
                    if (valid_in && ~stall_in) begin
                        valid_out <= 1'b1;
                        stall_out <= 1'b0;
                        branch_state <= 2'b01;
                    end else begin
                        valid_out <= 1'b0;
                        stall_out <= 1'b0;
                    end
                end
                2'b01: begin // Output valid state
                    if (stall_in) begin
                        valid_out <= 1'b0;
                        stall_out <= 1'b0;
                        branch_state <= 2'b00;
                    end
                end
            endcase
        end
    end

    // Merge node
    reg [1:0] merge_state;
    always @(posedge clock or negedge resetn) begin
        if (~resetn) begin
            merge_state <= 2'b00;
            // valid_in and stall_in won't be modified; keep inputs unchanged
        end else begin
            case (merge_state)
                2'b00: begin // Idle state
                    if (valid_out) begin
                        // valid_in is an input, do not assign
                        merge_state <= 2'b01;
                    end
                end
                2'b01: begin // Output stall state
                    if (~stall_out) begin
                        // stall_in is an input, do not assign
                        merge_state <= 2'b00;
                    end
                end
            endcase
            if (~valid_in || stall_out) begin
                // stall_in is an input, do not assign
            end
        end
    end

endmodule