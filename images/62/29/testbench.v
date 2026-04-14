`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    wire [255:0] CFG;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CFG(CFG)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verifying Device and Vendor ID...", test_num);






            #10;
            if (CFG[31:0] === 32'h000110EE) begin
                $display("PASS: Vendor/Device ID match (10EE/0001)");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Vendor/Device ID mismatch. Got: %h", CFG[31:0]);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verifying Class Code and Revision ID...", test_num);
            #10;

            if (CFG[95:64] === 32'h06000001) begin
                $display("PASS: Class Code and Revision ID match");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Class/Rev mismatch. Got: %h", CFG[95:64]);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verifying BAR0 initialization...", test_num);
            #10;

            if (CFG[159:128] === 32'hFF000000) begin
                $display("PASS: BAR0 matches expected base address");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: BAR0 mismatch. Got: %h", CFG[159:128]);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase004;

        reg [255:0] full_expected;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Full 256-bit Vector Validation...", test_num);




            full_expected = 256'h00000000_00000000_00000000_FF000000_00000000_06000001_00000000_000110EE;

            #1;


            check_outputs(full_expected);
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
        input [255:0] expected_CFG;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_CFG === (expected_CFG ^ CFG ^ expected_CFG)) begin
                $display("PASS");
                $display("  Outputs: CFG=%h",
                         CFG);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CFG=%h",
                         expected_CFG);
                $display("  Got:      CFG=%h",
                         CFG);
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
