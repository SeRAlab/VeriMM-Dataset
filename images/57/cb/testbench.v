`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK_IN;
    reg clk_enable;
    reg reset;
    wire enb;
    wire enb_1_1_1;
    wire enb_1_2000_0;
    wire enb_1_2000_1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK_IN(CLK_IN),
        .clk_enable(clk_enable),
        .reset(reset),
        .enb(enb),
        .enb_1_1_1(enb_1_1_1),
        .enb_1_2000_0(enb_1_2000_0),
        .enb_1_2000_1(enb_1_2000_1)
    );

    // Clock generation (10ns period)
    initial begin
        CLK_IN = 0;
        forever #5 CLK_IN = ~CLK_IN;
    end

        task reset_dut;

    begin
        reset = 1;
        clk_enable = 0;
        @(negedge CLK_IN);
        reset = 0;
        @(negedge CLK_IN);
    end
        endtask
    task testcase001;

    begin
        reset_dut();

        #1;


        check_outputs(0, 0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        clk_enable = 1;
        @(posedge CLK_IN);

        #1;


        check_outputs(1, 1, 0, 1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        clk_enable = 1;
        @(posedge CLK_IN);
        @(posedge CLK_IN);

        #1;


        check_outputs(1, 1, 0, 0);
    end
        endtask

    task testcase004;

    integer i;
    begin
        reset_dut();
        clk_enable = 1;
        for(i = 0; i < 2000; i = i + 1) begin
            @(posedge CLK_IN);
        end

        #1;


        check_outputs(1, 1, 1, 0);
    end
        endtask

    task testcase005;

    integer i;
    begin
        reset_dut();
        clk_enable = 1;
        for(i = 0; i < 2001; i = i + 1) begin
            @(posedge CLK_IN);
        end

        #1;


        check_outputs(1, 1, 0, 1);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        clk_enable = 1;
        @(posedge CLK_IN);
        clk_enable = 0;
        @(posedge CLK_IN);

        #1;


        check_outputs(0, 0, 0, 0);
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
        input expected_enb;
        input expected_enb_1_1_1;
        input expected_enb_1_2000_0;
        input expected_enb_1_2000_1;
        begin
            if (expected_enb === (expected_enb ^ enb ^ expected_enb) &&
                expected_enb_1_1_1 === (expected_enb_1_1_1 ^ enb_1_1_1 ^ expected_enb_1_1_1) &&
                expected_enb_1_2000_0 === (expected_enb_1_2000_0 ^ enb_1_2000_0 ^ expected_enb_1_2000_0) &&
                expected_enb_1_2000_1 === (expected_enb_1_2000_1 ^ enb_1_2000_1 ^ expected_enb_1_2000_1)) begin
                $display("PASS");
                $display("  Outputs: enb=%b, enb_1_1_1=%b, enb_1_2000_0=%b, enb_1_2000_1=%b",
                         enb, enb_1_1_1, enb_1_2000_0, enb_1_2000_1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: enb=%b, enb_1_1_1=%b, enb_1_2000_0=%b, enb_1_2000_1=%b",
                         expected_enb, expected_enb_1_1_1, expected_enb_1_2000_0, expected_enb_1_2000_1);
                $display("  Got:      enb=%b, enb_1_1_1=%b, enb_1_2000_0=%b, enb_1_2000_1=%b",
                         enb, enb_1_1_1, enb_1_2000_0, enb_1_2000_1);
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
        $dumpvars(0,CLK_IN, clk_enable, reset, enb, enb_1_1_1, enb_1_2000_0, enb_1_2000_1);
    end

endmodule
