`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] Data_A_i;
    reg [31:0] Data_B_i;
    reg clk;
    reg load_i;
    reg rst;
    wire [63:0] sgf_result_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Data_A_i(Data_A_i),
        .Data_B_i(Data_B_i),
        .clk(clk),
        .load_i(load_i),
        .rst(rst),
        .sgf_result_o(sgf_result_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            load_i = 0;
            Data_A_i = 0;
            Data_B_i = 0;
            repeat (2) @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset Check");
            reset_dut();

            #1;


            check_outputs(64'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: 0 * 0");
            reset_dut();
            Data_A_i = 32'h0;
            Data_B_i = 32'h0;
            load_i = 1;
            @(posedge clk);
            #1 load_i = 0;
            #1;

            check_outputs(64'h0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: 1234 * 5678");
            reset_dut();
            Data_A_i = 32'd1234;
            Data_B_i = 32'd5678;
            load_i = 1;
            @(posedge clk);
            #1 load_i = 0;
            #1;

            check_outputs(64'd1234 * 64'd5678);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: -10 * 50");
            reset_dut();
            Data_A_i = -32'd10;
            Data_B_i = 32'd50;
            load_i = 1;
            @(posedge clk);
            #1 load_i = 0;
            #1;

            check_outputs($signed(-64'd10) * $signed(64'd50));
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: 100 * -5");
            reset_dut();
            Data_A_i = 32'd100;
            Data_B_i = -32'd5;
            load_i = 1;
            @(posedge clk);
            #1 load_i = 0;
            #1;

            check_outputs($signed(64'd100) * $signed(-64'd5));
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: -20 * -30");
            reset_dut();
            Data_A_i = -32'd20;
            Data_B_i = -32'd30;
            load_i = 1;
            @(posedge clk);
            #1 load_i = 0;
            #1;

            check_outputs($signed(-64'd20) * $signed(-64'd30));
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Max Positive * Max Positive");
            reset_dut();
            Data_A_i = 32'h7FFFFFFF;
            Data_B_i = 32'h7FFFFFFF;
            load_i = 1;
            @(posedge clk);
            #1 load_i = 0;
            #1;

            check_outputs(64'h3FFFFFFF00000001);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Min Negative * 1");
            reset_dut();
            Data_A_i = 32'h80000000;
            Data_B_i = 32'h1;
            load_i = 1;
            @(posedge clk);
            #1 load_i = 0;
            #1;

            check_outputs(64'hFFFFFFFF80000000);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Min Negative * Min Negative");
            reset_dut();
            Data_A_i = 32'h80000000;
            Data_B_i = 32'h80000000;
            load_i = 1;
            @(posedge clk);
            #1 load_i = 0;

            #1;


            check_outputs(64'h4000000000000000);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Load Signal Sensitivity");
            reset_dut();

            Data_A_i = 32'd10;
            Data_B_i = 32'd10;
            load_i = 1;
            @(posedge clk);
            #1 load_i = 0;


            Data_A_i = 32'd999;
            Data_B_i = 32'd999;
            @(posedge clk);
            #1;

            #1;


            check_outputs(64'd100);
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
        testcase009();
        testcase010();
        
        
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
        input [63:0] expected_sgf_result_o;
        begin
            if (expected_sgf_result_o === (expected_sgf_result_o ^ sgf_result_o ^ expected_sgf_result_o)) begin
                $display("PASS");
                $display("  Outputs: sgf_result_o=%h",
                         sgf_result_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sgf_result_o=%h",
                         expected_sgf_result_o);
                $display("  Got:      sgf_result_o=%h",
                         sgf_result_o);
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
        $dumpvars(0,Data_A_i, Data_B_i, clk, load_i, rst, sgf_result_o);
    end

endmodule
