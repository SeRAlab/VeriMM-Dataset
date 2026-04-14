`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] SEL;
    wire [3:0] D_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .SEL(SEL),
        .D_OUT(D_OUT)
    );
    task testcase001;

        begin
            $display("Test Case 001: SEL = 0");
            test_num = 1;
            SEL = 2'b00;
            #1;

            check_outputs(4'b1110);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: SEL = 1");
            test_num = 2;
            SEL = 2'b01;
            #1;

            check_outputs(4'b1101);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: SEL = 2");
            test_num = 3;
            SEL = 2'b10;
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: SEL = 3");
            test_num = 4;
            SEL = 2'b11;
            #1;

            check_outputs(4'b0111);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Invalid SEL (Simulation 'x')");
            test_num = 5;
            SEL = 2'bxx;
            #1;

            check_outputs(4'b0000);
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
        input [3:0] expected_D_OUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_D_OUT === (expected_D_OUT ^ D_OUT ^ expected_D_OUT)) begin
                $display("PASS");
                $display("  Outputs: D_OUT=%h",
                         D_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D_OUT=%h",
                         expected_D_OUT);
                $display("  Got:      D_OUT=%h",
                         D_OUT);
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
