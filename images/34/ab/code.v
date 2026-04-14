module temperature_monitor (
    input wire clk, 
    input wire rst, 
    input wire [9:0] temperature, 
    output reg alert
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            alert <= 0;
        end else begin
            if (temperature < 10'd20 || temperature > 10'd30) begin
                alert <= 1;
            end else begin
                alert <= 0;
            end
        end
    end
endmodule