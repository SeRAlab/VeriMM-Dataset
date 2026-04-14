`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg EN;
    reg TE;
    wire [3:0] ENCLK;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .EN(EN),
        .TE(TE),
        .ENCLK(ENCLK)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            EN = 0;
            TE = 0;
            force dut.ENCLK = 4'd0;
            repeat(2) @(negedge CLK);
            release dut.ENCLK;
            $display("DUT Reset: ENCLK initialized to 0");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Basic Enable Counting (EN=1, TE=0)", test_num);
            reset_dut();

            @(negedge CLK);
            EN = 1;
            TE = 0;

            repeat(5) @(posedge CLK);


            @(negedge CLK);
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Test Enable Counting (EN=0, TE=1)", test_num);
            reset_dut();

            @(negedge CLK);
            EN = 0;
            TE = 1;

            repeat(10) @(posedge CLK);

            @(negedge CLK);
            #1;

            check_outputs(4'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Clock Gating (EN=0, TE=0)", test_num);
            reset_dut();

            @(negedge CLK);
            EN = 0;
            TE = 0;

            repeat(4) @(posedge CLK);

            @(negedge CLK);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Counter Overflow (16 cycles)", test_num);
            reset_dut();

            @(negedge CLK);
            EN = 1;
            TE = 0;

            repeat(16) @(posedge CLK);

            @(negedge CLK);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Mixed Enable/Test Signals", test_num);
            reset_dut();

            @(negedge CLK);

            EN = 1; TE = 0;
            repeat(2) @(posedge CLK);


            @(negedge CLK);
            EN = 0; TE = 0;
            repeat(2) @(posedge CLK);


            @(negedge CLK);
            EN = 0; TE = 1;
            repeat(3) @(posedge CLK);

            @(negedge CLK);
            #1;

            check_outputs(4'd5);
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
        input [3:0] expected_ENCLK;
        begin
            if (expected_ENCLK === (expected_ENCLK ^ ENCLK ^ expected_ENCLK)) begin
                $display("PASS");
                $display("  Outputs: ENCLK=%h",
                         ENCLK);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ENCLK=%h",
                         expected_ENCLK);
                $display("  Got:      ENCLK=%h",
                         ENCLK);
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
        $dumpvars(0,CLK, EN, TE, ENCLK);
    end

endmodule
