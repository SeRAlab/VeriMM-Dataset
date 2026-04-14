`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg DIR;
    reg EN;
    reg RST;
    wire [7:0] CNT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .DIR(DIR),
        .EN(EN),
        .RST(RST),
        .CNT(CNT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        RST = 1;
        #5;
        RST = 0;
        #10;
        RST = 1;
        @(posedge CLK);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Basic Up Counting", test_num);
        reset_dut();
        EN = 1;
        DIR = 1;
        repeat(10) @(posedge CLK);
        #1;
        #1;

        check_outputs(8'd10);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Basic Down Counting (Wrap-around)", test_num);
        reset_dut();
        EN = 1;
        DIR = 0;
        repeat(5) @(posedge CLK);
        #1;
        #1;

        check_outputs(8'd251);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Verify Enable=0 inhibits counting", test_num);
        reset_dut();
        EN = 0;
        DIR = 1;
        repeat(10) @(posedge CLK);
        #1;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Enable toggle mid-count", test_num);
        reset_dut();
        EN = 1; DIR = 1;
        repeat(5) @(posedge CLK);
        EN = 0;
        repeat(5) @(posedge CLK);
        #1;
        #1;

        check_outputs(8'd5);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Full upward wrap-around (256+ cycles)", test_num);
        reset_dut();
        EN = 1; DIR = 1;
        repeat(258) @(posedge CLK);
        #1;
        #1;

        check_outputs(8'd2);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Direction switch (Up then Down)", test_num);
        reset_dut();
        EN = 1; DIR = 1;
        repeat(20) @(posedge CLK);
        DIR = 0;
        repeat(5) @(posedge CLK);
        #1;
        #1;

        check_outputs(8'd15);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Full downward wrap-around", test_num);
        reset_dut();
        EN = 1; DIR = 0;
        repeat(257) @(posedge CLK);
        #1;
        #1;

        check_outputs(8'd255);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Complex sequence with EN and DIR changes", test_num);
        reset_dut();
        EN = 1; DIR = 1; repeat(10) @(posedge CLK);
        EN = 0; DIR = 0; repeat(5) @(posedge CLK);
        EN = 1; DIR = 0; repeat(2) @(posedge CLK);
        EN = 1; DIR = 1; repeat(4) @(posedge CLK);
        #1;
        #1;

        check_outputs(8'd12);
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
        input [7:0] expected_CNT;
        begin
            if (expected_CNT === (expected_CNT ^ CNT ^ expected_CNT)) begin
                $display("PASS");
                $display("  Outputs: CNT=%h",
                         CNT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CNT=%h",
                         expected_CNT);
                $display("  Got:      CNT=%h",
                         CNT);
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
        $dumpvars(0,CLK, DIR, EN, RST, CNT);
    end

endmodule
