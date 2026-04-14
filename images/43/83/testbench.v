`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg DATA_IN;
    reg EN;
    reg TE;
    wire [3:0] DATA_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .DATA_IN(DATA_IN),
        .EN(EN),
        .TE(TE),
        .DATA_OUT(DATA_OUT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        @(negedge CLK);
        EN = 1;
        TE = 0;
        DATA_IN = 0;
        repeat(4) @(negedge CLK);
        EN = 0;
        $display("DUT Reset Complete");
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Basic Shift 1011", test_num);
        reset_dut();

        @(negedge CLK); EN = 1; TE = 0; DATA_IN = 1;
        @(negedge CLK); DATA_IN = 0;
        @(negedge CLK); DATA_IN = 1;
        @(negedge CLK); DATA_IN = 1;
        @(negedge CLK); EN = 0;

        #1;


        check_outputs(4'b1011);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Enable Signal Control", test_num);
        reset_dut();

        @(negedge CLK); EN = 1; TE = 0; DATA_IN = 1;
        @(negedge CLK); EN = 0; DATA_IN = 1;
        @(negedge CLK); DATA_IN = 0;
        @(negedge CLK); EN = 1; DATA_IN = 1;
        @(negedge CLK); EN = 0;

        #1;


        check_outputs(4'b0011);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Test Enable (TE) Control", test_num);
        reset_dut();

        @(negedge CLK); EN = 0; TE = 1; DATA_IN = 1;
        @(negedge CLK); DATA_IN = 0;
        @(negedge CLK); DATA_IN = 1;
        @(negedge CLK); DATA_IN = 0;
        @(negedge CLK); TE = 0;

        #1;


        check_outputs(4'b1010);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Power Optimization / Gating", test_num);
        reset_dut();


        @(negedge CLK); EN = 1; TE = 0; DATA_IN = 1;
        repeat(3) @(negedge CLK);


        @(negedge CLK); EN = 0; TE = 0; DATA_IN = 0;
        repeat(4) @(negedge CLK);

        #1;


        check_outputs(4'b1111);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Left Shift Overflow (5 bits: 11001)", test_num);
        reset_dut();

        @(negedge CLK); EN = 1; TE = 0; DATA_IN = 1;
        @(negedge CLK); DATA_IN = 1;
        @(negedge CLK); DATA_IN = 0;
        @(negedge CLK); DATA_IN = 0;
        @(negedge CLK); DATA_IN = 1;
        @(negedge CLK); EN = 0;


        #1;



        check_outputs(4'b1001);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Simultaneous EN and TE active", test_num);
        reset_dut();

        @(negedge CLK); EN = 1; TE = 1; DATA_IN = 1;
        @(negedge CLK); DATA_IN = 0;
        @(negedge CLK); EN = 0; TE = 1; DATA_IN = 1;
        @(negedge CLK); EN = 1; TE = 0; DATA_IN = 0;
        @(negedge CLK); EN = 0; TE = 0;

        #1;


        check_outputs(4'b1010);
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
        input [3:0] expected_DATA_OUT;
        begin
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,CLK, DATA_IN, EN, TE, DATA_OUT);
    end

endmodule
