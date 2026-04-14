`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    reg [15:0] c;
    wire [15:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .y(y)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 16'sd10; b = 16'sd20; c = 16'sd30;
        $display("Test %0d: Positive Increasing", test_num);
        #1;

        check_outputs(16'sd30);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 16'sd500; b = 16'sd200; c = 16'sd100;
        $display("Test %0d: Positive Decreasing", test_num);
        #1;

        check_outputs(16'sd500);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = -16'sd50; b = -16'sd10; c = -16'sd100;
        $display("Test %0d: All Negative", test_num);
        #1;

        check_outputs(-16'sd10);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = -16'sd1000; b = 16'sd5; c = -16'sd1;
        $display("Test %0d: Mixed Sign", test_num);
        #1;

        check_outputs(16'sd5);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = -16'sd100; b = 16'sd0; c = -16'sd200;
        $display("Test %0d: Zero and Negatives", test_num);
        #1;

        check_outputs(16'sd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 16'sh7FFF; b = 16'sh0000; c = 16'sh8000;
        $display("Test %0d: Extreme Values", test_num);
        #1;

        check_outputs(16'sh7FFF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = -16'sd32768; b = -16'sd32767; c = -16'sd32766;
        $display("Test %0d: Extreme Negative Range", test_num);
        #1;

        check_outputs(-16'sd32766);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 16'sd42; b = 16'sd42; c = 16'sd10;
        $display("Test %0d: Duplicates (a=b)", test_num);
        #1;

        check_outputs(16'sd42);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        a = -16'sd1; b = -16'sd1; c = -16'sd1;
        $display("Test %0d: All Identical", test_num);
        #1;

        check_outputs(-16'sd1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        a = 16'sd100; b = 16'sd1000; c = 16'sd500;
        $display("Test %0d: Max at 'b'", test_num);
        #1;

        check_outputs(16'sd1000);
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
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [15:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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

endmodule
