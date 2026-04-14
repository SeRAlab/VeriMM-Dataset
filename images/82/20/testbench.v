`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg btn0;
    reg btn1;
    reg btn2;
    reg btn3;
    reg clk;
    reg [3:0] in;
    wire led0;
    wire led1;
    wire led2;
    wire led3;
    wire [6:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .btn0(btn0),
        .btn1(btn1),
        .btn2(btn2),
        .btn3(btn3),
        .clk(clk),
        .in(in),
        .led0(led0),
        .led1(led1),
        .led2(led2),
        .led3(led3),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            btn0 = 0;
            btn1 = 0;
            btn2 = 0;
            btn3 = 0;
            in = 4'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Hex 0, Btn 0", test_num);
            in = 4'h0;
            btn0 = 1;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(1, 0, 0, 0, 7'h3F);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Hex 1, Btn 1", test_num);
            in = 4'h1;
            btn1 = 1;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(0, 1, 0, 0, 7'h06);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Hex 5, Btn 2", test_num);
            in = 4'h5;
            btn2 = 1;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(0, 0, 1, 0, 7'h6D);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Hex 9, Btn 3", test_num);
            in = 4'h9;
            btn3 = 1;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(0, 0, 0, 1, 7'h6F);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Hex A, Btn 0", test_num);
            in = 4'hA;
            btn0 = 1;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(1, 0, 0, 0, 7'h77);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Hex F, Btn 2", test_num);
            in = 4'hF;
            btn2 = 1;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(0, 0, 1, 0, 7'h71);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Hex 8, Btn 1", test_num);
            in = 4'h8;
            btn1 = 1;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(0, 1, 0, 0, 7'h7F);
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
        testcase006();
        testcase007();
        
        
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
        input expected_led0;
        input expected_led1;
        input expected_led2;
        input expected_led3;
        input [6:0] expected_out;
        begin
            if (expected_led0 === (expected_led0 ^ led0 ^ expected_led0) &&
                expected_led1 === (expected_led1 ^ led1 ^ expected_led1) &&
                expected_led2 === (expected_led2 ^ led2 ^ expected_led2) &&
                expected_led3 === (expected_led3 ^ led3 ^ expected_led3) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: led0=%b, led1=%b, led2=%b, led3=%b, out=%h",
                         led0, led1, led2, led3, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: led0=%b, led1=%b, led2=%b, led3=%b, out=%h",
                         expected_led0, expected_led1, expected_led2, expected_led3, expected_out);
                $display("  Got:      led0=%b, led1=%b, led2=%b, led3=%b, out=%h",
                         led0, led1, led2, led3, out);
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
        $dumpvars(0,btn0, btn1, btn2, btn3, clk, in, led0, led1, led2, led3, out);
    end

endmodule
