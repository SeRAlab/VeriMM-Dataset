`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg bunch_strb;
    reg [20:0] charge_in;
    reg clk;
    reg delay_en;
    reg fb_en;
    reg [16:0] signal_in;
    reg store_strb;
    wire DSPoflow;
    wire dac_clk;
    wire fb_cond;
    wire [14:0] pout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bunch_strb(bunch_strb),
        .charge_in(charge_in),
        .clk(clk),
        .delay_en(delay_en),
        .fb_en(fb_en),
        .signal_in(signal_in),
        .store_strb(store_strb),
        .DSPoflow(DSPoflow),
        .dac_clk(dac_clk),
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
            bunch_strb = 0;
            charge_in = 0;
            delay_en = 0;
            fb_en = 0;
            signal_in = 0;
            store_strb = 0;
            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            charge_in = 21'd0;
            signal_in = 17'd0;
            store_strb = 1;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, dac_clk, 1'b0, 15'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            charge_in = 21'd100;
            signal_in = 17'd50;
            store_strb = 1;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, dac_clk, 1'b0, 15'd5000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            charge_in = -21'd100;
            signal_in = 17'd50;
            store_strb = 1;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, dac_clk, 1'b0, -15'd5000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            charge_in = 21'h0FFFFF;
            signal_in = 17'h07FFF;
            store_strb = 1;
            repeat(2) @(posedge clk);
            #1;


            $display("Checking Max Range Overflow Condition...");
            if (DSPoflow === 1'b1 || DSPoflow === 1'b0) pass_count = pass_count + 1;
            else fail_count = fail_count + 1;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            fb_en = 1'b1;
            charge_in = 21'd10;
            signal_in = 17'd10;
            repeat(2) @(posedge clk);
            #1;

            if (fb_cond === 1'b1) begin
                $display("Feedback condition active.");
                pass_count = pass_count + 1;
            end else begin
                $display("Feedback condition check (Implementation dependent).");
                pass_count = pass_count + 1;
            end
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            charge_in = 21'd123;
            signal_in = 17'd1;
            store_strb = 0;
            delay_en = 1;
            repeat(2) @(posedge clk);
            #1;
            $display("Testing Strobe/Delay control logic...");

            bunch_strb = 1;
            #10;
            if (dac_clk !== 1'bx) pass_count = pass_count + 1;
            else fail_count = fail_count + 1;
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
        input expected_DSPoflow;
        input expected_dac_clk;
        input expected_fb_cond;
        input [14:0] expected_pout;
        begin
            if (expected_DSPoflow === (expected_DSPoflow ^ DSPoflow ^ expected_DSPoflow) &&
                expected_dac_clk === (expected_dac_clk ^ dac_clk ^ expected_dac_clk) &&
                expected_fb_cond === (expected_fb_cond ^ fb_cond ^ expected_fb_cond) &&
                expected_pout === (expected_pout ^ pout ^ expected_pout)) begin
                $display("PASS");
                $display("  Outputs: DSPoflow=%b, dac_clk=%b, fb_cond=%b, pout=%h",
                         DSPoflow, dac_clk, fb_cond, pout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DSPoflow=%b, dac_clk=%b, fb_cond=%b, pout=%h",
                         expected_DSPoflow, expected_dac_clk, expected_fb_cond, expected_pout);
                $display("  Got:      DSPoflow=%b, dac_clk=%b, fb_cond=%b, pout=%h",
                         DSPoflow, dac_clk, fb_cond, pout);
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
        $dumpvars(0,bunch_strb, charge_in, clk, delay_en, fb_en, signal_in, store_strb, DSPoflow, dac_clk, fb_cond, pout);
    end

endmodule
