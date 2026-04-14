module top_module(
    input wire clk,
    input wire rst,
    input wire [7:0] in0,
    input wire [7:0] in1,
    input wire [7:0] in2,
    input wire [7:0] in3,
    output reg [3:0] anode,
    output reg [7:0] cathode
    );localparam N = 18;
    reg [N-1:0] q_reg;
    wire [N-1:0] q_next;
    
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            q_reg <= 0;
            anode <= 4'b1111;
            cathode <= 8'b00000000;
        end else begin
            q_reg <= q_next;
        end
    end
    
    assign q_next = q_reg + 1;
    
    always @(*) begin
        case (q_reg[N-1:N-2])
            2'b00: begin
                anode <= 4'b1110;
                cathode <= in0;
            end 
            2'b01: begin
                anode <= 4'b1101;
                cathode <= in1;
            end 
            2'b10: begin
                anode <= 4'b1011;
                cathode <= in2;
            end 
            default: begin
                anode <= 4'b0111;
                cathode <= in3;
            end 
        endcase
    end
    
endmodule