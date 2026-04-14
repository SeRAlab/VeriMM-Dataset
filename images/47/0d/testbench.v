`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] ctrl;
    wire [3:0] td_mode;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ctrl(ctrl),
        .td_mode(td_mode)
    );
    task testcase001;

    begin
        $display("Testcase 001: All zeros - Minimal input");
        test_num = 1;
        ctrl = 9'h000;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: All ones - Maximal input");
        test_num = 2;
        ctrl = 9'h1FF;
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Alternating bits (Pattern 0x55)");
        test_num = 3;
        ctrl = 9'h055;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Alternating bits (Pattern 0xAA)");
        test_num = 4;
        ctrl = 9'h0AA;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: High nibble activity check");
        test_num = 5;

        ctrl = 9'h1F0;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Mid-range value");
        test_num = 6;
        ctrl = 9'h012;
        #1;

        check_outputs(4'h2);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Walking one bit (Bit 3)");
        test_num = 7;
        ctrl = 9'h008;
        #1;

        check_outputs(4'h8);
    end
        endtask

    task testcase008;

    begin
        $display("Testcase 008: Walking one bit (Bit 0)");
        test_num = 8;
        ctrl = 9'h001;
        #1;

        check_outputs(4'h1);
    end
        endtask

    task testcase009;

    begin
        $display("Testcase 009: Full mode range (0x7)");
        test_num = 9;
        ctrl = 9'h007;
        #1;

        check_outputs(4'h7);
    end
        endtask

    task testcase010;

    begin
        $display("Testcase 010: High bit and mode combined");
        test_num = 10;
        ctrl = 9'h10B;
        #1;

        check_outputs(4'hB);
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
        input [3:0] expected_td_mode;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_td_mode === (expected_td_mode ^ td_mode ^ expected_td_mode)) begin
                $display("PASS");
                $display("  Outputs: td_mode=%h",
                         td_mode);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: td_mode=%h",
                         expected_td_mode);
                $display("  Got:      td_mode=%h",
                         td_mode);
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
