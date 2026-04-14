`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg z;
    wire [6:0] SSD;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .z(z),
        .SSD(SSD)
    );
    task testcase001;

        begin
            $display("\nRunning Testcase 001: z = 0");
            test_num = test_num + 1;
            z = 1'b0;

            #1;


            check_outputs(7'b0111111);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: z = 1");
            test_num = test_num + 1;
            z = 1'b1;

            #1;


            check_outputs(7'b0000110);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: z = X (Unknown)");
            test_num = test_num + 1;
            z = 1'bx;
            #1;
            $display("  Output for X: SSD=%b", SSD);

            pass_count = pass_count + 1;
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Rapid Switching");
            test_num = test_num + 1;
            z = 1'b0; #2;
            z = 1'b1; #2;
            z = 1'b0;
            #1;

            check_outputs(7'b0111111);
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
        input [6:0] expected_SSD;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_SSD === (expected_SSD ^ SSD ^ expected_SSD)) begin
                $display("PASS");
                $display("  Outputs: SSD=%h",
                         SSD);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SSD=%h",
                         expected_SSD);
                $display("  Got:      SSD=%h",
                         SSD);
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
