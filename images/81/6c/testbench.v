`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    reg en_in;
    reg halt_in;
    reg [4:0] length_in;
    reg length_pulse_in;
    reg length_wr_in;
    reg rst_in;
    wire en_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_in(clk_in),
        .en_in(en_in),
        .halt_in(halt_in),
        .length_in(length_in),
        .length_pulse_in(length_pulse_in),
        .length_wr_in(length_wr_in),
        .rst_in(rst_in),
        .en_out(en_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

    begin
        rst_in = 1;
        en_in = 0;
        halt_in = 0;
        length_in = 5'b0;
        length_pulse_in = 0;
        length_wr_in = 0;
        @(posedge clk_in);
        #1;
        rst_in = 0;
        @(posedge clk_in);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Running Testcase %0d: Basic countdown to zero", test_num);
        reset_dut();

        en_in = 1;
        length_in = 5'd5;
        length_wr_in = 1;
        @(posedge clk_in);
        #1;
        length_wr_in = 0;


        repeat(5) begin
            length_pulse_in = 1;
            @(posedge clk_in);
            #1;
            length_pulse_in = 0;
            @(posedge clk_in);
            #1;
        end

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running Testcase %0d: Countdown halfway", test_num);
        reset_dut();

        en_in = 1;
        length_in = 5'd10;
        length_wr_in = 1;
        @(posedge clk_in);
        #1;
        length_wr_in = 0;


        repeat(5) begin
            length_pulse_in = 1;
            @(posedge clk_in);
            #1;
            length_pulse_in = 0;
            @(posedge clk_in);
            #1;
        end

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Running Testcase %0d: Halt functionality", test_num);
        reset_dut();

        en_in = 1;
        halt_in = 1;
        length_in = 5'd2;
        length_wr_in = 1;
        @(posedge clk_in);
        #1;
        length_wr_in = 0;


        repeat(5) begin
            length_pulse_in = 1;
            @(posedge clk_in);
            #1;
            length_pulse_in = 0;
            @(posedge clk_in);
            #1;
        end

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running Testcase %0d: Master Enable logic", test_num);
        reset_dut();

        en_in = 1;
        length_in = 5'd15;
        length_wr_in = 1;
        @(posedge clk_in);
        #1;
        length_wr_in = 0;

        en_in = 0;
        @(posedge clk_in);
        #1;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Running Testcase %0d: Max value and boundary", test_num);
        reset_dut();

        en_in = 1;
        length_in = 5'b11111;
        length_wr_in = 1;
        @(posedge clk_in);
        #1;
        length_wr_in = 0;


        repeat(31) begin
            length_pulse_in = 1;
            @(posedge clk_in);
            #1;
            length_pulse_in = 0;
            @(posedge clk_in);
            #1;
        end


        length_pulse_in = 1;
        @(posedge clk_in);
        #1;
        length_pulse_in = 0;
        @(posedge clk_in);
        #1;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Running Testcase %0d: Pulse with zero length", test_num);
        reset_dut();

        en_in = 1;
        length_pulse_in = 1;
        @(posedge clk_in);
        #1;
        length_pulse_in = 0;
        @(posedge clk_in);
        #1;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Running Testcase %0d: Reload during countdown", test_num);
        reset_dut();

        en_in = 1;
        length_in = 5'd10;
        length_wr_in = 1;
        @(posedge clk_in);
        #1;
        length_wr_in = 0;


        repeat(5) begin
            length_pulse_in = 1;
            @(posedge clk_in);
            #1;
            length_pulse_in = 0;
            @(posedge clk_in);
            #1;
        end


        length_in = 5'd2;
        length_wr_in = 1;
        @(posedge clk_in);
        #1;
        length_wr_in = 0;


        repeat(2) begin
            length_pulse_in = 1;
            @(posedge clk_in);
            #1;
            length_pulse_in = 0;
            @(posedge clk_in);
            #1;
        end

        #1;


        check_outputs(1'b0);
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
        input expected_en_out;
        begin
            if (expected_en_out === (expected_en_out ^ en_out ^ expected_en_out)) begin
                $display("PASS");
                $display("  Outputs: en_out=%b",
                         en_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: en_out=%b",
                         expected_en_out);
                $display("  Got:      en_out=%b",
                         en_out);
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
        $dumpvars(0,clk_in, en_in, halt_in, length_in, length_pulse_in, length_wr_in, rst_in, en_out);
    end

endmodule
