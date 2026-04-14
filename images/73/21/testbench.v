`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    reg c;
    reg d;
    wire q;

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
        .q(q)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 0; b = 0; c = 0; d = 0;
        $display("Test Case 001: a=0, b=0, c=0, d=0");
        #1;

        check_outputs(1'b0);
    end
    endtask

    task testcase002;

    begin
        test_num = 2;
        a = 0; b = 0; c = 0; d = 1;
        $display("Test Case 002: a=0, b=0, c=0, d=1");
        #1;

        check_outputs(1'b1);
    end
    endtask

    task testcase003;

    begin
        test_num = 3;
        a = 0; b = 0; c = 1; d = 0;
        $display("Test Case 003: a=0, b=0, c=1, d=0");
        #1;

        check_outputs(1'b1);
    end
    endtask

    task testcase004;

    begin
        test_num = 4;
        a = 0; b = 0; c = 1; d = 1;
        $display("Test Case 004: a=0, b=0, c=1, d=1");
        #1;

        check_outputs(1'b1);
    end
    endtask

    task testcase005;

    begin
        test_num = 5;
        a = 0; b = 1; c = 0; d = 0;
        $display("Test Case 005: a=0, b=1, c=0, d=0");
        #1;

        check_outputs(1'b0);
    end
    endtask

    task testcase006;

    begin
        test_num = 6;
        a = 0; b = 1; c = 0; d = 1;
        $display("Test Case 006: a=0, b=1, c=0, d=1");
        #1;

        check_outputs(1'b1);
    end
    endtask

    task testcase007;

    begin
        test_num = 7;
        a = 0; b = 1; c = 1; d = 0;
        $display("Test Case 007: a=0, b=1, c=1, d=0");
        #1;

        check_outputs(1'b0);
    end
    endtask

    task testcase008;

    begin
        test_num = 8;
        a = 0; b = 1; c = 1; d = 1;
        $display("Test Case 008: a=0, b=1, c=1, d=1");
        #1;

        check_outputs(1'b1);
    end
    endtask

    task testcase009;

    begin
        test_num = 9;
        a = 1; b = 0; c = 0; d = 0;
        $display("Test Case 009: a=1, b=0, c=0, d=0");
        #1;

        check_outputs(1'b1);
    end
    endtask

    task testcase010;

    begin
        test_num = 10;
        a = 1; b = 0; c = 0; d = 1;
        $display("Test Case 010: a=1, b=0, c=0, d=1");
        #1;

        check_outputs(1'b1);
    end
    endtask

    task testcase011;

    begin
        test_num = 11;
        a = 1; b = 0; c = 1; d = 0;
        $display("Test Case 011: a=1, b=0, c=1, d=0");
        #1;

        check_outputs(1'b0);
    end
    endtask

    task testcase012;

    begin
        test_num = 12;
        a = 1; b = 0; c = 1; d = 1;
        $display("Test Case 012: a=1, b=0, c=1, d=1");
        #1;

        check_outputs(1'b0);
    end
    endtask

    task testcase013;

    begin
        test_num = 13;
        a = 1; b = 1; c = 0; d = 0;
        $display("Test Case 013: a=1, b=1, c=0, d=0");
        #1;

        check_outputs(1'b0);
    end
    endtask

    task testcase014;

    begin
        test_num = 14;
        a = 1; b = 1; c = 0; d = 1;
        $display("Test Case 014: a=1, b=1, c=0, d=1");
        #1;

        check_outputs(1'b1);
    end
    endtask

    task testcase015;

    begin
        test_num = 15;
        a = 1; b = 1; c = 1; d = 0;
        $display("Test Case 015: a=1, b=1, c=1, d=0");
        #1;

        check_outputs(1'b0);
    end
    endtask

    task testcase016;

    begin
        test_num = 16;
        a = 1; b = 1; c = 1; d = 1;
        $display("Test Case 016: a=1, b=1, c=1, d=1");
        #1;

        check_outputs(1'b0);
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
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input expected_q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%b",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b",
                         expected_q);
                $display("  Got:      q=%b",
                         q);
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
