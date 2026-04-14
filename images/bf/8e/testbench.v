`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] addr;
    reg [15:0] q0;
    reg [15:0] q1;
    reg [15:0] q2;
    reg [15:0] q3;
    reg [15:0] q4;
    reg [15:0] q5;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .q0(q0),
        .q1(q1),
        .q2(q2),
        .q3(q3),
        .q4(q4),
        .q5(q5),
        .q(q)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Selecting q0 (addr = 0)");
        q0 = 16'h1111; q1 = 16'h2222; q2 = 16'h3333;
        q3 = 16'h4444; q4 = 16'h5555; q5 = 16'h6666;
        addr = 3'd0;
        #1;

        check_outputs(16'h1111);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Selecting q1 (addr = 1)");
        q0 = 16'h1111; q1 = 16'h2222; q2 = 16'h3333;
        q3 = 16'h4444; q4 = 16'h5555; q5 = 16'h6666;
        addr = 3'd1;
        #1;

        check_outputs(16'h2222);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Selecting q2 (addr = 2)");
        q0 = 16'hAAAA; q1 = 16'hBBBB; q2 = 16'hCCCC;
        q3 = 16'hDDDD; q4 = 16'hEEEE; q5 = 16'hFFFF;
        addr = 3'd2;
        #1;

        check_outputs(16'hCCCC);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Selecting q3 (addr = 3)");
        q0 = 16'hAAAA; q1 = 16'hBBBB; q2 = 16'hCCCC;
        q3 = 16'hDDDD; q4 = 16'hEEEE; q5 = 16'hFFFF;
        addr = 3'd3;
        #1;

        check_outputs(16'hDDDD);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Selecting q4 (addr = 4)");
        q0 = 16'd100; q1 = 16'd200; q2 = 16'd300;
        q3 = 16'd400; q4 = 16'd500; q5 = 16'd600;
        addr = 3'd4;
        #1;

        check_outputs(16'd500);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Selecting q5 (addr = 5)");
        q0 = 16'd100; q1 = 16'd200; q2 = 16'd300;
        q3 = 16'd400; q4 = 16'd500; q5 = 16'd600;
        addr = 3'd5;
        #1;

        check_outputs(16'd600);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: Invalid Address (addr = 6), Default Output");
        q0 = 16'h1234; q1 = 16'h5678; q2 = 16'h9ABC;
        q3 = 16'hDEF0; q4 = 16'h1357; q5 = 16'h2468;
        addr = 3'd6;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 008: Invalid Address (addr = 7), Default Output");
        q0 = 16'h1234; q1 = 16'h5678; q2 = 16'h9ABC;
        q3 = 16'hDEF0; q4 = 16'h1357; q5 = 16'h2468;
        addr = 3'd7;
        #1;

        check_outputs(16'hFFFF);
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
        input [15:0] expected_q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
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
