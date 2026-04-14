`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] inA;
    reg [31:0] inB;
    wire [31:0] add_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .inA(inA),
        .inB(inB),
        .add_out(add_out)
    );
    task testcase001;

        begin
            $display("Testcase 001: Zero Addition");
            inA = 32'h00000000;
            inB = 32'h00000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Simple Positive Addition");
            inA = 32'd1000;
            inB = 32'd2500;
            #1;

            check_outputs(32'd3500);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Addition with Carry-out (Overflow bit ignored)");
            inA = 32'hFFFFFFFF;
            inB = 32'h00000001;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Two's Complement Negative Addition (-1 + 5)");
            inA = 32'hFFFFFFFF;
            inB = 32'h00000005;
            #1;

            check_outputs(32'h00000004);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Large Positive Values");
            inA = 32'h7FFFFFFF;
            inB = 32'h7FFFFFFF;
            #1;

            check_outputs(32'hFFFFFFFE);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Bitwise Alternating Patterns");
            inA = 32'hAAAAAAAA;
            inB = 32'h55555555;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Random Values Verification");
            inA = 32'h12345678;
            inB = 32'h87654321;
            #1;

            check_outputs(32'h99999999);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Result resulting in zero via negative sum");
            inA = 32'hEDCBA988;
            inB = 32'h12345678;
            #1;

            check_outputs(32'h00000000);
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
        input [31:0] expected_add_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_add_out === (expected_add_out ^ add_out ^ expected_add_out)) begin
                $display("PASS");
                $display("  Outputs: add_out=%h",
                         add_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: add_out=%h",
                         expected_add_out);
                $display("  Got:      add_out=%h",
                         add_out);
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
