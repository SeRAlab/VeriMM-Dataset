`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] DATA_IN;
    reg [3:0] MASK;
    wire [3:0] DATA_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DATA_IN(DATA_IN),
        .MASK(MASK),
        .DATA_OUT(DATA_OUT)
    );
    task testcase001;

        begin
            $display("Testcase 001: All zeros");
            DATA_IN = 4'b0000;
            MASK    = 4'b0000;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: All ones");
            DATA_IN = 4'b1111;
            MASK    = 4'b1111;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Pass-through (Mask is all ones)");
            DATA_IN = 4'b1010;
            MASK    = 4'b1111;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Blocking (Mask is all zeros)");
            DATA_IN = 4'b1111;
            MASK    = 4'b0000;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Complementary patterns");
            DATA_IN = 4'b1010;
            MASK    = 4'b0101;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Partial bit overlap (MSB only)");
            DATA_IN = 4'b1100;
            MASK    = 4'b1010;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Partial bit overlap (LSB only)");
            DATA_IN = 4'b0011;
            MASK    = 4'b0101;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Complex pattern 1");
            DATA_IN = 4'b0111;
            MASK    = 4'b0011;
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Complex pattern 2");
            DATA_IN = 4'b1110;
            MASK    = 4'b1011;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Alternating pattern check");
            DATA_IN = 4'b0101;
            MASK    = 4'b1111;
            #1;

            check_outputs(4'b0101);
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
        input [3:0] expected_DATA_OUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_DATA_OUT === (expected_DATA_OUT ^ DATA_OUT ^ expected_DATA_OUT)) begin
                $display("PASS");
                $display("  Outputs: DATA_OUT=%h",
                         DATA_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DATA_OUT=%h",
                         expected_DATA_OUT);
                $display("  Got:      DATA_OUT=%h",
                         DATA_OUT);
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
