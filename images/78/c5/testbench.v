`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [7:0] DATA_IN;
    reg LOAD;
    reg SHIFT;
    wire [7:0] Q_BAR_OUT;
    wire [7:0] Q_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .DATA_IN(DATA_IN),
        .LOAD(LOAD),
        .SHIFT(SHIFT),
        .Q_BAR_OUT(Q_BAR_OUT),
        .Q_OUT(Q_OUT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        LOAD = 1;
        SHIFT = 0;
        DATA_IN = 8'h00;
        @(posedge CLK);
        #1;
        LOAD = 0;
        DATA_IN = 8'h00;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase 001: Parallel Load 0xA5");
        LOAD = 1;
        SHIFT = 0;
        DATA_IN = 8'hA5;
        @(posedge CLK);
        #1;
        LOAD = 0;
        #1;

        check_outputs(8'h5A, 8'hA5);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase 002: Shift Left (Loading 0x0F, then shifting in 0)");

        LOAD = 1;
        DATA_IN = 8'h0F;
        @(posedge CLK);
        #1;

        LOAD = 0;
        SHIFT = 1;
        DATA_IN = 8'h00;
        @(posedge CLK);
        #1;
        SHIFT = 0;

        #1;


        check_outputs(8'hE1, 8'h1E);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase 003: Shift Left (Loading 0x55, then shifting in 1)");

        LOAD = 1;
        DATA_IN = 8'h55;
        @(posedge CLK);
        #1;

        LOAD = 0;
        SHIFT = 1;
        DATA_IN = 8'h01;
        @(posedge CLK);
        #1;
        SHIFT = 0;

        #1;


        check_outputs(8'h54, 8'hAB);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase 004: Multiple consecutive shifts");


        SHIFT = 1;
        DATA_IN = 8'h01;
        @(posedge CLK); #1;


        DATA_IN = 8'h01;
        @(posedge CLK); #1;


        DATA_IN = 8'h00;
        @(posedge CLK); #1;

        SHIFT = 0;

        #1;


        check_outputs(8'hF9, 8'h06);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase 005: Control Priority (LOAD and SHIFT both active)");

        LOAD = 1;
        SHIFT = 1;
        DATA_IN = 8'hFF;
        @(posedge CLK);
        #1;
        LOAD = 0;
        SHIFT = 0;

        #1;


        check_outputs(8'h00, 8'hFF);
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
        input [7:0] expected_Q_BAR_OUT;
        input [7:0] expected_Q_OUT;
        begin
            if (expected_Q_BAR_OUT === (expected_Q_BAR_OUT ^ Q_BAR_OUT ^ expected_Q_BAR_OUT) &&
                expected_Q_OUT === (expected_Q_OUT ^ Q_OUT ^ expected_Q_OUT)) begin
                $display("PASS");
                $display("  Outputs: Q_BAR_OUT=%h, Q_OUT=%h",
                         Q_BAR_OUT, Q_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q_BAR_OUT=%h, Q_OUT=%h",
                         expected_Q_BAR_OUT, expected_Q_OUT);
                $display("  Got:      Q_BAR_OUT=%h, Q_OUT=%h",
                         Q_BAR_OUT, Q_OUT);
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
        $dumpvars(0,CLK, DATA_IN, LOAD, SHIFT, Q_BAR_OUT, Q_OUT);
    end

endmodule
