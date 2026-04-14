module top_module(
    input signed [3:0] multiplicand,
    input signed [3:0] multiplier_in, // Changed the input multiplier to multipler_in
    input clock,
    input start,
    output reg signed [7:0] product,   // output product should be reg type
    output busy
);reg signed [7:0] product_reg;
reg [2:0] state;
reg busy_reg;
reg signed [3:0] multiplier; // Internal register for multiplier

always @(posedge clock) begin
    case(state)
        3'b000: begin
            product_reg <= 8'b00000000;
            multiplier <= multiplier_in; // Initialize multiplier from input
            state <= 3'b001;
        end
        3'b001: begin
            if (start) begin
                busy_reg <= 1;
                state <= 3'b010;
            end
        end
        3'b010: begin
            if (multiplier[0] == 1) begin
                product_reg <= product_reg - multiplicand;
            end else if (multiplier[0] == 0) begin
                product_reg <= product_reg + multiplicand;
            end
            multiplier <= {multiplier[2:0], multiplier[3]}; // Shift multiplier
            state <= 3'b011;
        end
        3'b011: begin
            multiplier <= {multiplier[2:0], multiplier[3]}; // Shift multiplier
            state <= 3'b100;
        end
        3'b100: begin
            multiplier <= {multiplier[2:0], multiplier[3]}; // Shift multiplier
            state <= 3'b010;
        end
    endcase
end

assign product = product_reg; // Output the product
assign busy = busy_reg; // Output the busy signal

always @(posedge clock) begin
    if(state == 3'b010 && multiplier == 4'b0000) begin
        busy_reg <= 0; // Set busy to 0 when multiplier is zero
    end
end

endmodule