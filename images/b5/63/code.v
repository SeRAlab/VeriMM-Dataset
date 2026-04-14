module top_module(input IN1, IN2, IN3, IN4, IN5, output QN, input VDD, VSS);wire w1, w2, w3;
    assign w1 = IN1 & IN2;
    assign w2 = ~(w1 & IN3);
    assign w3 = w2 & IN4 & IN5;
    assign QN = ~w3;
endmodule