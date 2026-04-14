`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] bin_in;
    reg en;
    wire [255:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bin_in(bin_in),
        .en(en),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Enable Low (en=0), bin_in=0. Expecting all outputs low.");
        en = 0;
        bin_in = 8'd0;
        #1;

        check_outputs(256'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Enable Low (en=0), bin_in=255. Expecting all outputs low.");
        en = 0;
        bin_in = 8'd255;
        #1;

        check_outputs(256'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Enable High, bin_in=0. Expecting out[0]=1.");
        en = 1;
        bin_in = 8'd0;
        #1;

        check_outputs(256'h1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Enable High, bin_in=1. Expecting out[1]=1.");
        en = 1;
        bin_in = 8'd1;
        #1;

        check_outputs(256'h2);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Enable High, bin_in=4. Expecting out[4]=1.");
        en = 1;
        bin_in = 8'd4;
        #1;

        check_outputs(256'h10);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase 006: Enable High, bin_in=8. Expecting out[8]=1.");
        en = 1;
        bin_in = 8'd8;
        #1;

        check_outputs(256'h100);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase 007: Enable High, bin_in=128. Expecting out[128]=1.");
        en = 1;
        bin_in = 8'd128;
        #1;

        check_outputs(256'h1 << 128);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase 008: Enable High, bin_in=255. Expecting out[255]=1.");
        en = 1;
        bin_in = 8'd255;
        #1;

        check_outputs(256'h1 << 255);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase 009: Transition en from 1 to 0 while bin_in=10.");
        en = 1;
        bin_in = 8'd10;
        #5;
        en = 0;
        #1;

        check_outputs(256'd0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase 010: Transition bin_in from 0 to 63 while en=1.");
        en = 1;
        bin_in = 8'd0;
        #5;
        bin_in = 8'd63;
        #1;

        check_outputs(256'h1 << 63);
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
        input [255:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
