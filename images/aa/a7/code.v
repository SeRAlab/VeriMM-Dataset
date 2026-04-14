module top_module(
    input [3:0] in,
    input a, b,
    output reg [1:0] pos,
    output reg cout,
    output reg sum,
    output reg [3:0] final_output
);// Priority Encoder
    always @(*) begin
        case(in)
            4'b0001: pos = 2'b00;
            4'b0010: pos = 2'b01;
            4'b0100: pos = 2'b10;
            4'b1000: pos = 2'b11;
            default: pos = 2'b00;
        endcase
    end

    // Half Adder
    always @(*) begin
        case({a,b})
            2'b00: begin
                sum = 1'b0;
                cout = 1'b0;
            end
            2'b01: begin
                sum = 1'b1;
                cout = 1'b0;
            end
            2'b10: begin
                sum = 1'b1;
                cout = 1'b0;
            end
            2'b11: begin
                sum = 1'b0;
                cout = 1'b1;
            end
        endcase
    end

    // Final Output
    always @(*) begin
        if(pos[0] == 1'b1) begin
            final_output = in + {1'b0, a, b};
        end
        else begin
            final_output = {1'b0, 1'b0, 1'b0, cout};
        end
    end

endmodule