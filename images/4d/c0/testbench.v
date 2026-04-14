`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [47:0] div_output;
    reg [47:0] subOut;
    wire [47:0] Mul_In;
    wire [47:0] op1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .div_output(div_output),
        .subOut(subOut),
        .Mul_In(Mul_In),
        .op1(op1)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        subOut = 48'd0;
        div_output = 48'd0;
        repeat(5) @(posedge clock);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Running Testcase %03d: Basic delay check", test_num);

        @(posedge clock);
        subOut = 48'hAAAA_BBBB_CCCC;
        div_output = 48'h1234_5678_9ABC;


        repeat(4) @(posedge clock);
        #1;

        #1;


        check_outputs(48'hAAAA_BBBB_CCCC, 48'h1234_5678_9ABC);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Running Testcase %03d: Maximum values check", test_num);

        @(posedge clock);
        subOut = 48'hFFFF_FFFF_FFFF;
        div_output = 48'hFFFF_FFFF_FFFF;

        repeat(4) @(posedge clock);
        #1;

        #1;


        check_outputs(48'hFFFF_FFFF_FFFF, 48'hFFFF_FFFF_FFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Running Testcase %03d: Pipeline sequence check", test_num);


        @(posedge clock);
        subOut = 48'h1;

        @(posedge clock);
        subOut = 48'h2;

        @(posedge clock);
        subOut = 48'h3;

        @(posedge clock);
        subOut = 48'h4;
        div_output = 48'hDEAF;


        #1;
        #1;

        check_outputs(48'h1, 48'hDEAF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Running Testcase %03d: op1 immediate reflection check", test_num);

        @(posedge clock);
        subOut = 48'hFEED_FACE;
        repeat(4) @(posedge clock);


        div_output = 48'hBEEF_BEEF;
        #1;


        #1;



        check_outputs(48'hFEED_FACE, 48'hBEEF_BEEF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Running Testcase %03d: Alternating bit pattern check", test_num);

        @(posedge clock);
        subOut = 48'h5555_AAAA_5555;
        div_output = 48'h0;

        repeat(4) @(posedge clock);
        #1;

        #1;


        check_outputs(48'h5555_AAAA_5555, 48'h0);
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
        input [47:0] expected_Mul_In;
        input [47:0] expected_op1;
        begin
            if (expected_Mul_In === (expected_Mul_In ^ Mul_In ^ expected_Mul_In) &&
                expected_op1 === (expected_op1 ^ op1 ^ expected_op1)) begin
                $display("PASS");
                $display("  Outputs: Mul_In=%h, op1=%h",
                         Mul_In, op1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Mul_In=%h, op1=%h",
                         expected_Mul_In, expected_op1);
                $display("  Got:      Mul_In=%h, op1=%h",
                         Mul_In, op1);
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
        $dumpvars(0,clock, div_output, subOut, Mul_In, op1);
    end

endmodule
