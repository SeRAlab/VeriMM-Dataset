module top_module(
    input clk,
    input reset, // Synchronous active-high reset
    input [7:0] d, // 8-bit input for the register
    input select, // Select input to choose between register and D flip-flops
    output reg [7:0] q, // 8-bit output from the active module
    output reg done // Signal indicating when all D flip-flops have finished loading their initial values
);reg [7:0] reg_out; // Output from the register
    reg [7:0] dff_out; // Output from the D flip-flops
    reg [7:0] and_out; // Output from the AND gate
    reg [7:0] init_val = 8'h3F; // Initial value for the D flip-flops
    reg [2:0] count = 3'b0; // Counter to track the number of D flip-flops that have finished loading their initial values

    // Register with active-high synchronous reset
    always @ (posedge clk or posedge reset) begin
        if (reset) begin
            reg_out <= 8'h3A;
        end else begin
            reg_out <= d;
        end
    end

    // D flip-flops with active-high synchronous reset
    always @ (posedge clk or posedge reset) begin
        if (reset) begin
            dff_out <= init_val;
        end else begin
            dff_out <= {dff_out[6:0], dff_out[7]};
        end
    end

    // AND gate to generate final output
    always @ (reg_out, dff_out) begin
        and_out = reg_out & dff_out;
    end

    // Control logic to select between register and D flip-flops
    always @ (select, reg_out, dff_out) begin
        if (select) begin
            q <= dff_out; // Change to non-blocking assignment
        end else begin
            q <= reg_out; // Change to non-blocking assignment
        end
    end

    // D flip-flop triggered by negative edge of the clock to generate done signal
    always @ (negedge clk or posedge reset) begin
        if (reset) begin
            count <= 3'b0;
            done <= 1'b0;
        end else begin
            if (count == 3'b111) begin
                done <= 1'b1;
            end else begin
                done <= 1'b0;
            end
            count <= count + 1; // Increment the counter
        end
    end

endmodule