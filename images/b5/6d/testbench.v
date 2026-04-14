`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_i;
    reg [4:0] degree_i;
    reg rst_i;
    wire [16:0] len_o;
    wire [15:0] mask_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_i(clk_i),
        .degree_i(degree_i),
        .rst_i(rst_i),
        .len_o(len_o),
        .mask_o(mask_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            rst_i = 1;
            degree_i = 0;
            @(posedge clk_i);
            #1;
            rst_i = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Checking Reset State", test_num);
            reset_dut();



            #1;




            check_outputs(17'h00000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Degree 3", test_num);
            reset_dut();
            degree_i = 5'd3;
            @(posedge clk_i);
            #1;
            #1;

            check_outputs(17'd7, 16'h0003);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Degree 4", test_num);
            reset_dut();
            degree_i = 5'd4;
            @(posedge clk_i);
            #1;
            #1;

            check_outputs(17'd15, 16'h0003);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Degree 8", test_num);
            reset_dut();
            degree_i = 5'd8;
            @(posedge clk_i);
            #1;
            #1;

            check_outputs(17'd255, 16'h001D);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Degree 12", test_num);
            reset_dut();
            degree_i = 5'd12;
            @(posedge clk_i);
            #1;
            #1;

            check_outputs(17'd4095, 16'h0829);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Degree 16", test_num);
            reset_dut();
            degree_i = 5'd16;
            @(posedge clk_i);
            #1;
            #1;

            check_outputs(17'd65535, 16'h100B);
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
        input [16:0] expected_len_o;
        input [15:0] expected_mask_o;
        begin
            if (expected_len_o === (expected_len_o ^ len_o ^ expected_len_o) &&
                expected_mask_o === (expected_mask_o ^ mask_o ^ expected_mask_o)) begin
                $display("PASS");
                $display("  Outputs: len_o=%h, mask_o=%h",
                         len_o, mask_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: len_o=%h, mask_o=%h",
                         expected_len_o, expected_mask_o);
                $display("  Got:      len_o=%h, mask_o=%h",
                         len_o, mask_o);
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
        $dumpvars(0,clk_i, degree_i, rst_i, len_o, mask_o);
    end

endmodule
