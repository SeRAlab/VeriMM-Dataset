`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg EN;
    reg TE;
    reg [31:0] W;
    wire ENCLK;
    wire [31:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .EN(EN),
        .TE(TE),
        .W(W),
        .ENCLK(ENCLK),
        .Y(Y)
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
        W = 32'h0;

        repeat (2) @(negedge CLK);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Test Case %0d: TE=1, EN=0 (Test Mode Enable)", test_num);

        TE = 1;
        EN = 0;
        W = 32'hA5A5_A5A5;

        @(posedge CLK);
        #1;

        #1;


        check_outputs(1'b1, 32'hA5A5_A5A5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Test Case %0d: TE=0, EN=1 (Normal Mode Enable)", test_num);

        TE = 0;
        EN = 1;
        W = 32'h1234_5678;

        @(posedge CLK);
        #1;
        #1;

        check_outputs(1'b1, 32'h1234_5678);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        reset_dut();


        EN = 1; TE = 0; W = 32'hBBBB_BBBB;
        @(posedge CLK); #1;

        $display("Test Case %0d: TE=0, EN=0 (Clock Gated/Disabled)", test_num);

        @(negedge CLK);
        TE = 0;
        EN = 0;
        W = 32'hFFFF_FFFF;

        @(posedge CLK);
        #1;

        #1;


        check_outputs(1'b0, 32'hBBBB_BBBB);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Test Case %0d: TE=1, EN=1 (Dual Enable)", test_num);

        TE = 1;
        EN = 1;
        W = 32'hDEAD_BEEF;

        @(posedge CLK);
        #1;
        #1;

        check_outputs(1'b1, 32'hDEAD_BEEF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Test Case %0d: Data stability when ENCLK is LOW", test_num);

        TE = 0;
        EN = 0;
        W = 32'h0000_1111;

        @(posedge CLK);
        #2;
        W = 32'h0000_2222;
        #1;
        #1;

        check_outputs(1'b0, 32'h0000_0000);
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
        input expected_ENCLK;
        input [31:0] expected_Y;
        begin
            if (expected_ENCLK === (expected_ENCLK ^ ENCLK ^ expected_ENCLK) &&
                expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: ENCLK=%b, Y=%h",
                         ENCLK, Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ENCLK=%b, Y=%h",
                         expected_ENCLK, expected_Y);
                $display("  Got:      ENCLK=%b, Y=%h",
                         ENCLK, Y);
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
        $dumpvars(0,CLK, EN, TE, W, ENCLK, Y);
    end

endmodule
