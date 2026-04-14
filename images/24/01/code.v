module current_sensor_comparator(input [7:0] current_limit, input [7:0] current_sense, output alert);  
    assign alert = (current_sense > current_limit) ? 1'b1 : 1'b0;  
endmodule