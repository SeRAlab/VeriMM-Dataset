module top_module(
    input UD,
    input CLK,
    input RST,
    input LD,
    input SEL,
    input signed [3:0] A,
    input signed [3:0] B,
    output reg signed [3:0] C,
    output reg [3:0] Q
);// Up-Down Counter Module
reg [3:0] count;
always @(posedge CLK or negedge RST) begin
    if (RST == 0) begin
        count <= 4'b0000;
    end else if (UD == 1) begin
        count <= count + 1;
    end else if (UD == 0) begin
        count <= count - 1;
    end
end

// Booth's Multiplier Module
reg [7:0] product;
reg [3:0] multiplicand;
always @(posedge CLK or negedge RST) begin
    if (RST == 0) begin
        product <= 8'b00000000;
        multiplicand <= 4'b0000;
    end else begin
        case ({product[0], A[3:2]}) 
            2'b01: begin
                product <= {product[7:1], A[1:0], 1'b0};
                multiplicand <= multiplicand + B;
            end
            2'b10: begin
                product <= {product[7:1], A[1:0], 1'b0};
                multiplicand <= multiplicand - B;
            end
            2'b11: begin
                product <= {product[7:1], A[1:0], 1'b0};
            end
            default: begin
                product <= {product[7:1], A[1:0], 1'b0};
            end
        endcase
    end
end
assign C = product[7:4];
assign Q = (SEL == 1) ? multiplicand : count;

// Functional Module
reg signed [3:0] sum;
always @(posedge CLK or negedge RST) begin
    if (RST == 0) begin
        sum <= 4'b0000;
    end else begin
        sum <= Q + C;
    end
end

endmodule