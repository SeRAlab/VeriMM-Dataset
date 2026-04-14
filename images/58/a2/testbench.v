`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] a_in;
    reg [1:0] b_in;
    reg [1:0] c_in;
    reg clock;
    reg [1:0] d_in;
    reg [1:0] e_in;
    reg [1:0] f_in;
    reg reset_n;
    wire [3:0] out0;
    wire [3:0] out1;
    wire [3:0] out2;
    wire [3:0] out3;
    wire [3:0] out4;
    wire [3:0] out5;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a_in(a_in),
        .b_in(b_in),
        .c_in(c_in),
        .clock(clock),
        .d_in(d_in),
        .e_in(e_in),
        .f_in(f_in),
        .reset_n(reset_n),
        .out0(out0),
        .out1(out1),
        .out2(out2),
        .out3(out3),
        .out4(out4),
        .out5(out5)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        reset_n = 0;
        a_in = 0;
        b_in = 0;
        c_in = 0;
        d_in = 0;
        e_in = 0;
        f_in = 0;
        @(posedge clock);
        #1;
        reset_n = 1;
        @(posedge clock);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Reset and Zero Inputs", test_num);
        reset_dut();



        #1;




        check_outputs(4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Maximum Inputs (Overflow/Truncation Check)", test_num);
        reset_dut();
        a_in = 2'b11; b_in = 2'b11;
        c_in = 2'b11; d_in = 2'b11;
        e_in = 2'b11; f_in = 2'b11;


        @(posedge clock);
        #1;






        #1;







        check_outputs(4'h2, 4'h2, 4'h2, 4'h9, 4'h9, 4'h9);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Mixed Small Values", test_num);
        reset_dut();
        a_in = 2'd1; b_in = 2'd2;
        c_in = 2'd3; d_in = 2'd1;
        e_in = 2'd2; f_in = 2'd2;

        @(posedge clock);
        #1;




        #1;





        check_outputs(4'h5, 4'h7, 4'h6, 4'h2, 4'h3, 4'h4);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Multiplication by Zero", test_num);
        reset_dut();
        a_in = 2'd3; b_in = 2'd0;
        c_in = 2'd0; d_in = 2'd2;
        e_in = 2'd1; f_in = 2'd3;

        @(posedge clock);
        #1;




        #1;





        check_outputs(4'h0, 4'h3, 4'h3, 4'h0, 4'h0, 4'h3);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Exact 15 (4'hF) Result", test_num);
        reset_dut();
        a_in = 2'd3; b_in = 2'd3;
        c_in = 2'd2; d_in = 2'd3;
        e_in = 2'd1; f_in = 2'd0;

        @(posedge clock);
        #1;




        #1;





        check_outputs(4'hF, 4'h6, 4'h9, 4'h9, 4'h6, 4'h0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input [3:0] expected_out0;
        input [3:0] expected_out1;
        input [3:0] expected_out2;
        input [3:0] expected_out3;
        input [3:0] expected_out4;
        input [3:0] expected_out5;
        begin
            if (expected_out0 === (expected_out0 ^ out0 ^ expected_out0) &&
                expected_out1 === (expected_out1 ^ out1 ^ expected_out1) &&
                expected_out2 === (expected_out2 ^ out2 ^ expected_out2) &&
                expected_out3 === (expected_out3 ^ out3 ^ expected_out3) &&
                expected_out4 === (expected_out4 ^ out4 ^ expected_out4) &&
                expected_out5 === (expected_out5 ^ out5 ^ expected_out5)) begin
                $display("PASS");
                $display("  Outputs: out0=%h, out1=%h, out2=%h, out3=%h, out4=%h, out5=%h",
                         out0, out1, out2, out3, out4, out5);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out0=%h, out1=%h, out2=%h, out3=%h, out4=%h, out5=%h",
                         expected_out0, expected_out1, expected_out2, expected_out3, expected_out4, expected_out5);
                $display("  Got:      out0=%h, out1=%h, out2=%h, out3=%h, out4=%h, out5=%h",
                         out0, out1, out2, out3, out4, out5);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,a_in, b_in, c_in, clock, d_in, e_in, f_in, reset_n, out0, out1, out2, out3, out4, out5);
    end

endmodule
