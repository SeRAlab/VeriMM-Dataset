`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    wire display_en;
    wire logic_en;
    wire logic_en_1;
    wire pix_en;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .display_en(display_en),
        .logic_en(logic_en),
        .logic_en_1(logic_en_1),
        .pix_en(pix_en)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            repeat (2) @(posedge clk);
            #1 rst = 0;
            $display("\nReset completed...");
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %03d: Post-Reset State", test_num);
            reset_dut();
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %03d: State at Counter = 1", test_num);
            reset_dut();
            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %03d: State at Counter = 4 (pix_en check)", test_num);
            reset_dut();
            repeat (5) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %03d: Mid-range counter check", test_num);
            reset_dut();
            repeat (10) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0, 1'b0);
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
        input expected_display_en;
        input expected_logic_en;
        input expected_logic_en_1;
        input expected_pix_en;
        begin
            if (expected_display_en === (expected_display_en ^ display_en ^ expected_display_en) &&
                expected_logic_en === (expected_logic_en ^ logic_en ^ expected_logic_en) &&
                expected_logic_en_1 === (expected_logic_en_1 ^ logic_en_1 ^ expected_logic_en_1) &&
                expected_pix_en === (expected_pix_en ^ pix_en ^ expected_pix_en)) begin
                $display("PASS");
                $display("  Outputs: display_en=%b, logic_en=%b, logic_en_1=%b, pix_en=%b",
                         display_en, logic_en, logic_en_1, pix_en);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: display_en=%b, logic_en=%b, logic_en_1=%b, pix_en=%b",
                         expected_display_en, expected_logic_en, expected_logic_en_1, expected_pix_en);
                $display("  Got:      display_en=%b, logic_en=%b, logic_en_1=%b, pix_en=%b",
                         display_en, logic_en, logic_en_1, pix_en);
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
        $dumpvars(0,clk, rst, display_en, logic_en, logic_en_1, pix_en);
    end

endmodule
