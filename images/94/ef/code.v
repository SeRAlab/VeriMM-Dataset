module top_module(
    input             clk,
    input             rst,
    input             real_speed,
    input             rst_counter,
    input             irq_n,
    input             uart_speed,
    output reg        ym_pm,
    output reg [31:0] pm_counter
);parameter stop=5'd07;
reg [4:0] div_cnt, cambio0, cambio1; 

// Multiplexer for selecting clock speed
always @(posedge clk or posedge rst) begin : speed_mux
    if (rst) begin
        cambio0 <= 5'd2;
        cambio1 <= 5'd4;
    end else begin
        if (real_speed) begin
            cambio0 <= 5'd2;
            cambio1 <= 5'd4;
        end else begin
            if (uart_speed) begin
                cambio0 <= 5'd4;
                cambio1 <= 5'd8;
            end else begin
                cambio0 <= 5'd7;
                cambio1 <= 5'd15;
            end
        end
    end
end

// Flip-flop for generating ym_pm signal
always @(posedge clk or posedge rst) begin : ym_pm_ff
    if (rst) begin
        div_cnt <= 5'd0;
        ym_pm <= 1'b0;
    end else begin    
        if (div_cnt >= cambio1) begin
            ym_pm <= 1'b1;
            div_cnt <= 5'd0;
        end else begin
            if (div_cnt == cambio0) begin
                ym_pm <= 1'b0;
            end
            div_cnt <= div_cnt + 1'b1;
        end
    end
end

// Flip-flop for generating pm_counter signal
reg ultpm;
always @(posedge clk or posedge rst) begin : pm_counter_ff
    if (rst) begin
        pm_counter <= 32'd0;
        ultpm <= 1'b0;
    end else begin
        ultpm <= ym_pm;
        if (rst_counter) begin
            pm_counter <= 32'd0;
        end else begin
            if (irq_n && ym_pm && !ultpm) begin
                pm_counter <= pm_counter + 1'd1;        
            end
        end
    end
end

endmodule