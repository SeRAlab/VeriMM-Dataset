module top_module(
    input clk, // clock input for binary counter
    input reset, // reset input for binary counter
    input [31:0] a, // 32-bit input for multiplier
    input [31:0] b, // 32-bit input for multiplier
    output reg [31:0] product // 32-bit output from multiplier
    );reg [3:0] counter; // 4-bit binary counter
    
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            counter <= 4'b0000; // reset counter to 0000
            product <= a * b; // set initial product to a * b
        end
        else begin
            if (counter == 4'b1111) begin
                counter <= 4'b0000; // reset counter to 0000
            end
            else begin
                counter <= counter + 1; // increment counter
            end
            
            // select multiplier output based on counter value
            case (counter)
                4'b0000: product <= a * b;
                4'b0001: product <= a * (b << 1);
                4'b0010: product <= (a << 2) * b;
                4'b0011: product <= (a << 3) * (b >> 1);
                4'b0100: product <= a * (b / 3);
                4'b0101: product <= a * (b / 5);
                4'b0110: product <= a * (b / 7);
                4'b0111: product <= a * (b / 9);
            endcase
        end
    end
endmodule