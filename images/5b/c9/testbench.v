`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] a;
    reg i;
    wire U;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .i(i),
        .U(U)
    );
    task testcase001;

        begin
            $display("Test Case 001: State I (00), i=0");
            a = 2'b00;
            i = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: State I (00), i=1");
            a = 2'b00;
            i = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: State J (01), i=0");
            a = 2'b01;
            i = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: State J (01), i=1");
            a = 2'b01;
            i = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: State K (10), i=0");
            a = 2'b10;
            i = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: State K (10), i=1");
            a = 2'b10;
            i = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: State L (11), i=0");
            a = 2'b11;
            i = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: State L (11), i=1");
            a = 2'b11;
            i = 1'b1;
            #1;

            check_outputs(1'b1);
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
        input expected_U;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_U === (expected_U ^ U ^ expected_U)) begin
                $display("PASS");
                $display("  Outputs: U=%b",
                         U);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: U=%b",
                         expected_U);
                $display("  Got:      U=%b",
                         U);
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
