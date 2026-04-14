module monte_carlo_pi (
    input wire [7:0] x,
    input wire [7:0] y,
    input wire clk,
    output reg inside_circle,
    output reg [9:0] count
);
    reg [9:0] temp_count;

    always @(*) begin
        if ((x * x + y * y) < 8'hFF) // Check if x^2 + y^2 < 1 (scaled)
            inside_circle = 1'b1;
        else
            inside_circle = 1'b0;
    end
    
    always @(posedge clk) begin
        if (inside_circle)
            temp_count <= temp_count + 1;
    end

    always @(posedge clk) begin
        count <= temp_count;
    end
endmodule