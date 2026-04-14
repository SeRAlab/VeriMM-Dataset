module top_module(din, read, write, id, clk, dout, 
    gpio_pin1);input [15:0] din;
    input [5:0] id;
    input read, write, clk;

    
    output [15:0] dout;
    output gpio_pin1;

    
    reg [7:0] R[4:0];

    
    assign dout = (read && id[5])? {8'h00, R[id[4:0]]} : 16'hzzzz;

    
    assign gpio_pin1 = R[0][0];

    
    always @ (posedge clk) 
    begin
        
        if(write && id[5])
            R[id[4:0]] <= din[7:0];
    end    

endmodule