`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [25:0] Data_A_i;
    reg [25:0] Data_B_i;
    reg clk;
    reg load_b_i;
    reg rst;
    wire [51:0] sgf_result_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Data_A_i(Data_A_i),
        .Data_B_i(Data_B_i),
        .clk(clk),
        .load_b_i(load_b_i),
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
            load_b_i = 0;
            Data_A_i = 0;
            Data_B_i = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero multiplication", test_num);
            reset_dut();

            @(posedge clk);
            load_b_i = 1;
            Data_B_i = 26'sd0;
            @(posedge clk);
            load_b_i = 0;
            Data_A_i = 26'sd0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(52'sd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple positive multiplication", test_num);
            reset_dut();

            @(posedge clk);
            load_b_i = 1;
            Data_B_i = 26'sd456;
            @(posedge clk);
            load_b_i = 0;
            Data_A_i = 26'sd123;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(52'sd56088);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative A * Positive B", test_num);
            reset_dut();

            @(posedge clk);
            load_b_i = 1;
            Data_B_i = 26'sd50;
            @(posedge clk);
            load_b_i = 0;
            Data_A_i = -26'sd100;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(-52'sd5000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Positive A * Negative B", test_num);
            reset_dut();

            @(posedge clk);
            load_b_i = 1;
            Data_B_i = -26'sd30;
            @(posedge clk);
            load_b_i = 0;
            Data_A_i = 26'sd200;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(-52'sd6000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative A * Negative B", test_num);
            reset_dut();

            @(posedge clk);
            load_b_i = 1;
            Data_B_i = -26'sd20;
            @(posedge clk);
            load_b_i = 0;
            Data_A_i = -26'sd15;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(52'sd300);
        end
        endtask

    task testcase006;

        reg signed [25:0] max_pos;
        reg signed [51:0] expected;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max positive multiplication", test_num);
            max_pos = 26'sh1FFFFFF;
            expected = 52'sd1125899839733761;
            reset_dut();

            @(posedge clk);
            load_b_i = 1;
            Data_B_i = max_pos;
            @(posedge clk);
            load_b_i = 0;
            Data_A_i = max_pos;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(expected);
        end
        endtask

    task testcase007;

        reg signed [25:0] max_neg;
        reg signed [51:0] expected;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max negative multiplication", test_num);
            max_neg = 26'sh2000000;
            expected = 52'sd1125899906842624;
            reset_dut();

            @(posedge clk);
            load_b_i = 1;
            Data_B_i = max_neg;
            @(posedge clk);
            load_b_i = 0;
            Data_A_i = max_neg;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(expected);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load control verification", test_num);
            reset_dut();


            @(posedge clk);
            load_b_i = 1;
            Data_B_i = 26'sd10;
            @(posedge clk);
            load_b_i = 0;
            Data_B_i = 26'sd999;
            Data_A_i = 26'sd5;

            repeat(2) @(posedge clk);

            #1;


            check_outputs(52'sd50);
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
        input [51:0] expected_sgf_result_o;
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
        $dumpvars(0,Data_A_i, Data_B_i, clk, load_b_i, rst, sgf_result_o);
    end

endmodule
