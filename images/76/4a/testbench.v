`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] rot;
    wire [15:0] block;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .rot(rot),
        .block(block)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Running Test Case 001: rot = 0 (Rotation 0)");
            rot = 2'b00;





            #1;






            check_outputs(16'h4460);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Test Case 002: rot = 1 (Rotation 1)");
            rot = 2'b01;





            #1;






            check_outputs(16'h0E80);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Test Case 003: rot = 2 (Rotation 2)");
            rot = 2'b10;





            #1;






            check_outputs(16'hC440);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Test Case 004: rot = 3 (Rotation 3)");
            rot = 2'b11;





            #1;






            check_outputs(16'h2E00);
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
        input [15:0] expected_block;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_block === (expected_block ^ block ^ expected_block)) begin
                $display("PASS");
                $display("  Outputs: block=%h",
                         block);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: block=%h",
                         expected_block);
                $display("  Got:      block=%h",
                         block);
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
