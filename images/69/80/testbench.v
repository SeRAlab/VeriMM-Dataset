`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    reg c;
    reg d;
    wire [1:0] binary_code;
    wire highest_priority;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .binary_code(binary_code),
        .highest_priority(highest_priority)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: All inputs inactive", test_num);
        a = 0; b = 0; c = 0; d = 0;
        #1;

        check_outputs(2'b00, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Only input 'a' active (Index 00)", test_num);
        a = 1; b = 0; c = 0; d = 0;
        #1;

        check_outputs(2'b00, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Only input 'b' active (Index 01)", test_num);
        a = 0; b = 1; c = 0; d = 0;
        #1;

        check_outputs(2'b01, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Only input 'c' active (Index 10)", test_num);
        a = 0; b = 0; c = 1; d = 0;
        #1;

        check_outputs(2'b10, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Only input 'd' active (Index 11)", test_num);
        a = 0; b = 0; c = 0; d = 1;
        #1;

        check_outputs(2'b11, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Inputs 'a' and 'b' active ('b' priority)", test_num);
        a = 1; b = 1; c = 0; d = 0;
        #1;

        check_outputs(2'b01, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Inputs 'a' and 'c' active ('c' priority)", test_num);
        a = 1; b = 0; c = 1; d = 0;
        #1;

        check_outputs(2'b10, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Inputs 'b' and 'c' active ('c' priority)", test_num);
        a = 0; b = 1; c = 1; d = 0;
        #1;

        check_outputs(2'b10, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: Inputs 'a' and 'd' active ('d' priority)", test_num);
        a = 1; b = 0; c = 0; d = 1;
        #1;

        check_outputs(2'b11, 1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: All inputs active ('d' priority)", test_num);
        a = 1; b = 1; c = 1; d = 1;
        #1;

        check_outputs(2'b11, 1'b1);
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
        input [1:0] expected_binary_code;
        input expected_highest_priority;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_binary_code === (expected_binary_code ^ binary_code ^ expected_binary_code) &&
                expected_highest_priority === (expected_highest_priority ^ highest_priority ^ expected_highest_priority)) begin
                $display("PASS");
                $display("  Outputs: binary_code=%h, highest_priority=%b",
                         binary_code, highest_priority);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: binary_code=%h, highest_priority=%b",
                         expected_binary_code, expected_highest_priority);
                $display("  Got:      binary_code=%h, highest_priority=%b",
                         binary_code, highest_priority);
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
