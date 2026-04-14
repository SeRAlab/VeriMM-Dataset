module top_module(
    input clk,
    input reset,      // Synchronous active-high reset
    input [7:0] d,    // 8-bit input for the register
    input select,     // Select input to choose between register and counter
    output reg [7:0] q    // Changed output to reg type
);// Register module from problem 1
reg [7:0] reg_q;
always @(posedge clk) begin
    if (reset) begin
        reg_q <= 8'b0;
    end else begin
        reg_q <= d;
    end
end

// Counter module from problem 2
reg [7:0] cnt_q;
always @(posedge clk) begin
    if (reset) begin
        cnt_q <= 8'b0;
    end else begin
        cnt_q <= cnt_q + 1;
    end
end

// Functional module to perform bitwise XOR operation
reg [7:0] xor_q;
always @(posedge clk) begin
    if (reset) begin
        xor_q <= 8'b0;
    end else begin
        if (select) begin
            xor_q <= reg_q ^ cnt_q;
        end else begin
            xor_q <= reg_q;
        end
    end
end

// Control logic module to select between register and counter
reg [1:0] stage;
always @(posedge clk) begin
    if (reset) begin
        stage <= 2'b00;
    end else begin
        case (stage)
            2'b00: begin
                stage <= 2'b01;
            end
            2'b01: begin
                stage <= 2'b10;
            end
            2'b10: begin
                stage <= 2'b00;
            end
        endcase
    end
end

// Output selection
always @(posedge clk) begin
    if (reset) begin
        q <= 8'b0;
    end else begin
        case (stage)
            2'b00: begin
                q <= xor_q;
            end
            2'b01: begin
                q <= reg_q;
            end
            2'b10: begin
                q <= cnt_q;
            end
        endcase
    end
end

endmodule