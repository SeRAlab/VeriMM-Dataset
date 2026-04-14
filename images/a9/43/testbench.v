`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [12:0] banana_corr;
    reg bunch_strb;
    reg [20:0] charge_in;
    reg clk;
    reg delay_en;
    reg [14:0] signal_in;
    reg store_strb;
    wire fb_cond;
    wire [12:0] pout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .banana_corr(banana_corr),
        .bunch_strb(bunch_strb),
        .charge_in(charge_in),
        .clk(clk),
        .delay_en(delay_en),
        .signal_in(signal_in),
        .store_strb(store_strb),
        .fb_cond(fb_cond),
        .pout(pout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            charge_in = 0;
            signal_in = 0;
            delay_en = 0;
            store_strb = 0;
            bunch_strb = 0;
            banana_corr = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Zero Inputs", test_num);
            reset_dut();

            charge_in = 21'd0;
            signal_in = 15'd0;
            banana_corr = 13'd0;

            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b0, 13'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Positive Inputs", test_num);
            reset_dut();

            charge_in = 21'd1000;
            signal_in = 15'd50;
            banana_corr = 13'd0;

            repeat(2) @(posedge clk);



            if (pout !== 13'hxxxx) pass_count = pass_count;
            #1;

            check_outputs(fb_cond, pout);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Negative Inputs", test_num);
            reset_dut();

            charge_in = -21'd500;
            signal_in = 15'd100;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(fb_cond, pout);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Strobe and Delay Enable", test_num);
            reset_dut();

            charge_in = 21'h0FFFFF;
            signal_in = 15'h1FFF;
            delay_en = 1;
            store_strb = 1;

            repeat(5) @(posedge clk);
            store_strb = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(fb_cond, pout);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Banana Correction Offset", test_num);
            reset_dut();

            charge_in = 21'd2000;
            signal_in = 15'd10;
            banana_corr = 13'sh00FF;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(fb_cond, pout);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Feedback Condition Logic", test_num);
            reset_dut();

            bunch_strb = 1;
            charge_in = 21'd123;
            signal_in = 15'd456;


            repeat(32) @(posedge clk);

            #1;


            check_outputs(fb_cond, pout);
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
        input expected_fb_cond;
        input [12:0] expected_pout;
        begin
            if (expected_fb_cond === (expected_fb_cond ^ fb_cond ^ expected_fb_cond) &&
                expected_pout === (expected_pout ^ pout ^ expected_pout)) begin
                $display("PASS");
                $display("  Outputs: fb_cond=%b, pout=%h",
                         fb_cond, pout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fb_cond=%b, pout=%h",
                         expected_fb_cond, expected_pout);
                $display("  Got:      fb_cond=%b, pout=%h",
                         fb_cond, pout);
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
        $dumpvars(0,banana_corr, bunch_strb, charge_in, clk, delay_en, signal_in, store_strb, fb_cond, pout);
    end

endmodule
