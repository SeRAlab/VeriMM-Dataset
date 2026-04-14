module divider_8bit(
    input clk,          // Chip clock signal.
    input rst_n,        // Active-low reset signal. Defined as 0 for chip reset; defined as 1 for reset signal inactive.
    input start,        // Chip enable signal.
    input [7:0] dividend, // Input dividend with a data width of 8 bits.
    input [7:0] divisor,  // Input divisor with a data width of 8 bits.

    output [7:0] qout,  // Quotient output with a data width of 8 bits.
    output [7:0] rout,  // Remainder output with a data width of 8 bits.
    output done         // Chip output flag signal. Defined as 1 indicates division operation completion.
);

reg [7:0] areg;    // Dividend register.
reg [7:0] breg;    // Divisor register.
reg [7:0] qout_r;  // Quotient register.
reg [7:0] rout_r;  // Remainder register.
reg done_r;
reg [3:0] i;      // Count register.

//------------------------------------------------
// Data bit control
always @(posedge clk or negedge rst_n)
    if (!rst_n) i <= 4'd0;
    else if (start && i < 4'd9) i <= i + 1'b1;
    else if (!start) i <= 4'd0;

//------------------------------------------------
// Division completion flag generation
always @(posedge clk or negedge rst_n)
    if (!rst_n) done_r <= 1'b0;
    else if (i == 4'd8) done_r <= 1'b1; // Division completion flag
    else if (i == 4'd9) done_r <= 1'b0; // Flag reset

assign done = done_r;

//------------------------------------------------
// Dedicated register for non-restoring division operation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        areg <= 8'h00;
        breg <= 8'h00;
        qout_r <= 8'h00;
        rout_r <= 8'h00;
    end
    else if (start) begin // Start operation
        if (i == 4'd0) begin // Store dividend and divisor
            areg <= dividend;
            breg <= divisor;
            qout_r <= 8'h00;
            rout_r <= 8'h00;
        end
        else if (i > 4'd0 && i < 4'd9) begin
            if (areg >= (breg << (8 - i))) begin
                areg <= areg - (breg << (8 - i));
                qout_r[8 - i] <= 1'b1;
            end else begin
                qout_r[8 - i] <= 1'b0;
            end
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) rout_r <= 8'h00;
    else if (i == 4'd8) rout_r <= areg;
end

assign qout = qout_r;
assign rout = rout_r;

endmodule