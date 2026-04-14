`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [63:0] C;
    reg CLK;
    reg RST;
    reg start;
    wire [63:0] Cminus1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .C(C),
        .CLK(CLK),
        .RST(RST),
        .start(start),
        .Cminus1(Cminus1)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            start = 0;
            C = 0;
            @(posedge CLK);
            #1 RST = 0;
            @(posedge CLK);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset Initialization", test_num);
            reset_dut();
            #1;

            check_outputs(64'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Basic Data Capture", test_num);
            reset_dut();
            @(negedge CLK);
            C = 64'hFEDCBA9876543210;
            start = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(64'hFEDCBA9876543210);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Start Gating Logic", test_num);
            reset_dut();
            @(negedge CLK);
            C = 64'hFFFFFFFFFFFFFFFF;
            start = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(64'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Data Persistence", test_num);
            reset_dut();
            @(negedge CLK);
            C = 64'hA5A5A5A55A5A5A5A;
            start = 1;
            @(posedge CLK);
            @(negedge CLK);
            start = 0;
            C = 64'h0000000000000000;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(64'hA5A5A5A55A5A5A5A);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Consecutive Updates", test_num);
            reset_dut();
            @(negedge CLK);
            start = 1;
            C = 64'h1111222233334444;
            @(posedge CLK);
            @(negedge CLK);
            C = 64'h5555666677778888;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(64'h5555666677778888);
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
        input [63:0] expected_Cminus1;
        begin
            if (expected_Cminus1 === (expected_Cminus1 ^ Cminus1 ^ expected_Cminus1)) begin
                $display("PASS");
                $display("  Outputs: Cminus1=%h",
                         Cminus1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Cminus1=%h",
                         expected_Cminus1);
                $display("  Got:      Cminus1=%h",
                         Cminus1);
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
        $dumpvars(0,C, CLK, RST, start, Cminus1);
    end

endmodule
