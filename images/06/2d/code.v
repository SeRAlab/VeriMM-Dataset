module vco (
    input wire clk,
    input wire rst,
    input wire [2:0] control,
    output reg out
);
    reg [2:0] count;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            out <= 0;
            count <= 0;
        end else begin
            case (control)
                3'b000: count <= (count == 3'b111) ? 0 : count + 1;
                3'b001: count <= (count == 3'b011) ? 0 : count + 1;
                3'b010: count <= (count == 3'b001) ? 0 : count + 1;
                3'b011: count <= 0; // toggle every clock cycle
                3'b100: count <= 0; // stable output
                default: count <= 0;
            endcase
            
            if (control == 3'b011) begin
                out <= ~out; // Toggle output
            end else if (count == 3'b111) begin
                out <= ~out; // Toggle output based on count for other cases
            end
        end
    end
endmodule