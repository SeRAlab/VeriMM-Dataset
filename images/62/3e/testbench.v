`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [63:0] D;
    reg en;
    reg reset;
    wire [63:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .D(D),
        .en(en),
        .reset(reset),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            reset = 1;
            en = 0;
            D = 0;
            @(posedge CLK);
            #1;
            reset = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Basic Reset Verification", test_num);
            reset_dut();

            #1;


            check_outputs(64'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Loading Data with Enable", test_num);
            reset_dut();
            en = 1;
            D = 64'hA5A5A5A55A5A5A5A;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(64'hA5A5A5A55A5A5A5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Loading Data then Holding", test_num);
            reset_dut();

            en = 1;
            D = 64'h1234567890ABCDEF;
            @(posedge CLK);
            #1;

            en = 0;
            D = 64'hFFFFFFFFFFFFFFFF;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(64'h1234567890ABCDEF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Reset Priority over Enable", test_num);
            reset_dut();

            reset = 1;
            en = 1;
            D = 64'hCAFEBABECAFEBABE;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(64'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: All Ones Pattern", test_num);
            reset_dut();
            en = 1;
            D = 64'hFFFFFFFFFFFFFFFF;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(64'hFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Sequential Load", test_num);
            reset_dut();
            en = 1;
            D = 64'h1;
            @(posedge CLK);
            #1;
            D = 64'h2;
            @(posedge CLK);
            #1;
            D = 64'h3;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(64'h3);
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
        input [63:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,CLK, D, en, reset, Q);
    end

endmodule
