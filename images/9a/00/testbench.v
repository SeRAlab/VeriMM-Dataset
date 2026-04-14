`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg CLR;
    reg [3:0] DATA;
    reg LD;
    reg RST;
    wire [4:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .CLR(CLR),
        .DATA(DATA),
        .LD(LD),
        .RST(RST),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        RST = 1;
        CLR = 1;
        LD = 0;
        DATA = 0;
        @(negedge CLK);
        RST = 0;
        CLR = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Basic Reset Check", test_num);
        reset_dut();

        #1;


        check_outputs(5'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Simple Count (3 cycles)", test_num);
        reset_dut();
        repeat(3) @(negedge CLK);

        #1;


        check_outputs(5'd6);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Load Data into Async Counter", test_num);
        reset_dut();
        DATA = 4'd12;
        LD = 1;
        @(negedge CLK);

        LD = 0;
        #1;

        check_outputs(5'd13);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Clear Async Counter while running", test_num);
        reset_dut();
        repeat(5) @(negedge CLK);
        CLR = 1;
        @(negedge CLK);

        CLR = 0;
        #1;

        check_outputs(5'd6);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Load then Increment", test_num);
        reset_dut();
        DATA = 4'd5;
        LD = 1;
        @(negedge CLK);
        LD = 0;
        repeat(2) @(negedge CLK);
        #1;

        check_outputs(5'd10);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Counter Rollover (16 cycles)", test_num);
        reset_dut();
        repeat(16) @(negedge CLK);


        #1;



        check_outputs(5'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: CLR priority over LD", test_num);
        reset_dut();
        CLR = 1;
        LD = 1;
        DATA = 4'hF;
        @(negedge CLK);

        CLR = 0;
        LD = 0;
        #1;

        check_outputs(5'd1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Binary counter reset (RST)", test_num);
        reset_dut();
        repeat(4) @(negedge CLK);
        RST = 1;
        @(negedge CLK);

        RST = 0;
        #1;

        check_outputs(5'd5);
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
        input [4:0] expected_Q;
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
        $dumpvars(0,CLK, CLR, DATA, LD, RST, Q);
    end

endmodule
