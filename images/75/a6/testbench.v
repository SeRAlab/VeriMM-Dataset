`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clr;
    reg [15:0] cntr_def_0;
    reg [15:0] cntr_def_1;
    reg [15:0] cntr_def_2;
    reg [15:0] cntr_def_3;
    reg [15:0] cntr_def_4;
    reg [15:0] cntr_def_5;
    reg [15:0] cntr_def_6;
    reg [15:0] cntr_def_7;
    reg incrementor;
    reg reverse;
    reg selector;
    wire [15:0] cntr0;
    wire [15:0] cntr1;
    wire [15:0] cntr2;
    wire [15:0] cntr3;
    wire [15:0] cntr4;
    wire [15:0] cntr5;
    wire [15:0] cntr6;
    wire [15:0] cntr7;
    wire [7:0] cntr_ind;
    wire [15:0] cntr_sel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clr(clr),
        .cntr_def_0(cntr_def_0),
        .cntr_def_1(cntr_def_1),
        .cntr_def_2(cntr_def_2),
        .cntr_def_3(cntr_def_3),
        .cntr_def_4(cntr_def_4),
        .cntr_def_5(cntr_def_5),
        .cntr_def_6(cntr_def_6),
        .cntr_def_7(cntr_def_7),
        .incrementor(incrementor),
        .reverse(reverse),
        .selector(selector),
        .cntr0(cntr0),
        .cntr1(cntr1),
        .cntr2(cntr2),
        .cntr3(cntr3),
        .cntr4(cntr4),
        .cntr5(cntr5),
        .cntr6(cntr6),
        .cntr7(cntr7),
        .cntr_ind(cntr_ind),
        .cntr_sel(cntr_sel)
    );

        task reset_dut;

        begin
            clr = 1;
            selector = 0;
            incrementor = 0;
            reverse = 0;
            cntr_def_0 = 16'h0000;
            cntr_def_1 = 16'h0001;
            cntr_def_2 = 16'h0002;
            cntr_def_3 = 16'h0003;
            cntr_def_4 = 16'h0004;
            cntr_def_5 = 16'h0005;
            cntr_def_6 = 16'h0006;
            cntr_def_7 = 16'h0007;
            #20;
            clr = 0;
            #20;
        end
        endtask
    task pulse_selector;

        begin
            selector = 1; #10;
            selector = 0; #10;
        end
        endtask

    task pulse_incrementor;

        begin
            incrementor = 1; #10;
            incrementor = 0; #10;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(16'h0, 16'h1, 16'h2, 16'h3, 16'h4, 16'h5, 16'h6, 16'h7, 8'h01, 16'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            reverse = 0;
            pulse_selector();
            #1;

            check_outputs(16'h0, 16'h1, 16'h2, 16'h3, 16'h4, 16'h5, 16'h6, 16'h7, 8'h02, 16'h1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            reverse = 1;
            pulse_selector();
            #1;

            check_outputs(16'h0, 16'h1, 16'h2, 16'h3, 16'h4, 16'h5, 16'h6, 16'h7, 8'h80, 16'h7);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            reverse = 0;
            pulse_incrementor();
            pulse_incrementor();
            #1;

            check_outputs(16'h2, 16'h1, 16'h2, 16'h3, 16'h4, 16'h5, 16'h6, 16'h7, 8'h01, 16'h2);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            reverse = 1;
            pulse_incrementor();
            #1;

            check_outputs(16'hFFFF, 16'h1, 16'h2, 16'h3, 16'h4, 16'h5, 16'h6, 16'h7, 8'h01, 16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            reverse = 0;
            pulse_selector();
            pulse_selector();
            pulse_incrementor();
            #1;

            check_outputs(16'h0, 16'h1, 16'h3, 16'h4, 16'h5, 16'h6, 16'h7, 16'h8, 8'h04, 16'h3);


        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            reverse = 0;
            pulse_incrementor();
            pulse_selector();
            pulse_incrementor();
            pulse_incrementor();
            reverse = 1;
            pulse_selector();
            pulse_incrementor();
            #1;

            check_outputs(16'h0, 16'h3, 16'h2, 16'h3, 16'h4, 16'h5, 16'h6, 16'h7, 8'h01, 16'h0);
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
        input [15:0] expected_cntr0;
        input [15:0] expected_cntr1;
        input [15:0] expected_cntr2;
        input [15:0] expected_cntr3;
        input [15:0] expected_cntr4;
        input [15:0] expected_cntr5;
        input [15:0] expected_cntr6;
        input [15:0] expected_cntr7;
        input [7:0] expected_cntr_ind;
        input [15:0] expected_cntr_sel;
        begin
            if (expected_cntr0 === (expected_cntr0 ^ cntr0 ^ expected_cntr0) &&
                expected_cntr1 === (expected_cntr1 ^ cntr1 ^ expected_cntr1) &&
                expected_cntr2 === (expected_cntr2 ^ cntr2 ^ expected_cntr2) &&
                expected_cntr3 === (expected_cntr3 ^ cntr3 ^ expected_cntr3) &&
                expected_cntr4 === (expected_cntr4 ^ cntr4 ^ expected_cntr4) &&
                expected_cntr5 === (expected_cntr5 ^ cntr5 ^ expected_cntr5) &&
                expected_cntr6 === (expected_cntr6 ^ cntr6 ^ expected_cntr6) &&
                expected_cntr7 === (expected_cntr7 ^ cntr7 ^ expected_cntr7) &&
                expected_cntr_ind === (expected_cntr_ind ^ cntr_ind ^ expected_cntr_ind) &&
                expected_cntr_sel === (expected_cntr_sel ^ cntr_sel ^ expected_cntr_sel)) begin
                $display("PASS");
                $display("  Outputs: cntr0=%h, cntr1=%h, cntr2=%h, cntr3=%h, cntr4=%h, cntr5=%h, cntr6=%h, cntr7=%h, cntr_ind=%h, cntr_sel=%h",
                         cntr0, cntr1, cntr2, cntr3, cntr4, cntr5, cntr6, cntr7, cntr_ind, cntr_sel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cntr0=%h, cntr1=%h, cntr2=%h, cntr3=%h, cntr4=%h, cntr5=%h, cntr6=%h, cntr7=%h, cntr_ind=%h, cntr_sel=%h",
                         expected_cntr0, expected_cntr1, expected_cntr2, expected_cntr3, expected_cntr4, expected_cntr5, expected_cntr6, expected_cntr7, expected_cntr_ind, expected_cntr_sel);
                $display("  Got:      cntr0=%h, cntr1=%h, cntr2=%h, cntr3=%h, cntr4=%h, cntr5=%h, cntr6=%h, cntr7=%h, cntr_ind=%h, cntr_sel=%h",
                         cntr0, cntr1, cntr2, cntr3, cntr4, cntr5, cntr6, cntr7, cntr_ind, cntr_sel);
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
        $dumpvars(0,clr, cntr_def_0, cntr_def_1, cntr_def_2, cntr_def_3, cntr_def_4, cntr_def_5, cntr_def_6, cntr_def_7, incrementor, reverse, selector, cntr0, cntr1, cntr2, cntr3, cntr4, cntr5, cntr6, cntr7, cntr_ind, cntr_sel);
    end

endmodule
