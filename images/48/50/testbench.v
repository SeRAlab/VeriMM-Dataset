`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    wire [1535:0] DOUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DOUT(DOUT)
    );
    task testcase001;

        reg [1535:0] expected_val;
        integer i;
        begin
            $display("Test Case 001: Verifying complete ROM data concatenation...");
            test_num = test_num + 1;


            for (i = 0; i < 64; i = i + 1) begin
                expected_val[i*24 +: 24] = i[23:0];
            end
            #1;

            check_outputs(expected_val);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Verifying boundary indices (Word 0 and Word 63)...");
            test_num = test_num + 1;
            #1;

            if (DOUT[23:0] === 24'd0 && DOUT[1535:1512] === 24'd63) begin
                $display("PASS: Word 0 = 0 and Word 63 = 63");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Boundary mismatch detected!");
                $display("  Word 0 (expected 0): %d", DOUT[23:0]);
                $display("  Word 63 (expected 63): %d", DOUT[1535:1512]);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase003;

        integer mid_idx;
        reg [23:0] mid_val;
        begin
            mid_idx = 32;
            $display("Test Case 003: Verifying middle index (Word %0d)...", mid_idx);
            test_num = test_num + 1;
            #1;
            mid_val = DOUT[mid_idx*24 +: 24];
            if (mid_val === 24'd32) begin
                $display("PASS: Word 32 = 32");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Word 32 mismatch! Got: %d", mid_val);
                fail_count = fail_count + 1;
            end
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
        input [1535:0] expected_DOUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_DOUT === (expected_DOUT ^ DOUT ^ expected_DOUT)) begin
                $display("PASS");
                $display("  Outputs: DOUT=%h",
                         DOUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DOUT=%h",
                         expected_DOUT);
                $display("  Got:      DOUT=%h",
                         DOUT);
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
