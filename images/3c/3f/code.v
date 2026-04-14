module slam (
    input wire clk,
    input wire rst,
    input wire signed [7:0] x_disp,
    input wire signed [7:0] y_disp,
    output reg signed [15:0] position
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            position <= 16'sd0;
        end else begin
            position <= position + {x_disp, y_disp}; // Combine x and y displacements
        end
    end
endmodule