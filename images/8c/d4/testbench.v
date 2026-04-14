`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] inp;
    wire [15:0] res;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .inp(inp),
        .res(res)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case 001: All Zeros");
        inp = 16'h0000;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case 002: LSB set");
        inp = 16'h0001;
        #1;

        check_outputs(16'h0002);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case 003: MSB set (overflow check)");
        inp = 16'h8000;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case 004: All Ones");
        inp = 16'hFFFF;
        #1;

        check_outputs(16'hFFFE);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case 005: Alternating bits (5555)");
        inp = 16'h5555;
        #1;

        check_outputs(16'hAAAA);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case 006: Alternating bits (AAAA)");
        inp = 16'hAAAA;
        #1;

        check_outputs(16'h5554);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case 007: Lower Byte Full");
        inp = 16'h00FF;
        #1;

        check_outputs(16'h01FE);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case 008: Upper Byte Full");
        inp = 16'hFF00;
        #1;

        check_outputs(16'hFE00);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case 009: Pattern 1234");
        inp = 16'h1234;
        #1;

        check_outputs(16'h2468);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case 010: Boundary Middle bit");
        inp = 16'h0080;
        #1;

        check_outputs(16'h0100);
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
        input [15:0] expected_res;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_res === (expected_res ^ res ^ expected_res)) begin
                $display("PASS");
                $display("  Outputs: res=%h",
                         res);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: res=%h",
                         expected_res);
                $display("  Got:      res=%h",
                         res);
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
