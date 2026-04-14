`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] DM;
    reg clk;
    wire [31:0] R;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DM(DM),
        .clk(clk),
        .R(R)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            DM = 32'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            DM = 32'hDEADBEEF;
            @(posedge clk);
            #2;
            $display("Testcase 001: Capture 0xDEADBEEF");
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            DM = 32'hAAAAAAAA;
            @(posedge clk);
            #2;
            $display("Testcase 002: Capture 0xAAAAAAAA");
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            DM = 32'h00000000;
            @(posedge clk);
            #2;
            $display("Testcase 003: Capture 0x00000000");
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            DM = 32'hFFFFFFFF;
            @(posedge clk);
            #2;
            $display("Testcase 004: Capture 0xFFFFFFFF");
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            DM = 32'h80000000;
            @(posedge clk);
            #2;
            $display("Testcase 005: Capture 0x80000000");
            #1;

            check_outputs(32'h80000000);
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
        input [31:0] expected_R;
        begin
            if (expected_R === (expected_R ^ R ^ expected_R)) begin
                $display("PASS");
                $display("  Outputs: R=%h",
                         R);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: R=%h",
                         expected_R);
                $display("  Got:      R=%h",
                         R);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,DM, clk, R);
    end

endmodule
