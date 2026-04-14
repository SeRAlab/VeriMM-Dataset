`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] CLP_work_time;
    reg clk;
    reg enable;
    reg rst;
    wire [11:0] CLP_ctr_cnt;
    wire state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLP_work_time(CLP_work_time),
        .clk(clk),
        .enable(enable),
        .rst(rst),
        .CLP_ctr_cnt(CLP_ctr_cnt),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            enable = 0;
            CLP_work_time = 16'd0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial Reset State", test_num);
            reset_dut();
            #1;

            check_outputs(12'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Basic Count to 10", test_num);
            reset_dut();
            CLP_work_time = 16'd10;
            enable = 1;
            @(posedge clk);
            #1 enable = 0;

            repeat(15) @(posedge clk);
            #1;

            check_outputs(12'd10, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Reset during operation", test_num);
            reset_dut();
            CLP_work_time = 16'd100;
            enable = 1;
            @(posedge clk);
            #1 enable = 0;
            repeat(10) @(posedge clk);
            rst = 1;
            @(posedge clk);
            #1 rst = 0;
            #1;

            check_outputs(12'd0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Work time of 1 cycle", test_num);
            reset_dut();
            CLP_work_time = 16'd1;
            enable = 1;
            @(posedge clk);
            #1 enable = 0;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(12'd1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Hold enable signal high", test_num);
            reset_dut();
            CLP_work_time = 16'd5;
            enable = 1;
            repeat(20) @(posedge clk);

            #1;


            check_outputs(12'd5, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Large work time (12-bit max)", test_num);
            reset_dut();
            CLP_work_time = 16'hFFF;
            enable = 1;
            @(posedge clk);
            #1 enable = 0;



            CLP_work_time = 16'd200;
            repeat(210) @(posedge clk);
            #1;

            check_outputs(12'd200, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: No enable signal", test_num);
            reset_dut();
            CLP_work_time = 16'd50;
            enable = 0;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(12'd0, 1'b0);
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
        input [11:0] expected_CLP_ctr_cnt;
        input expected_state;
        begin
            if (expected_CLP_ctr_cnt === (expected_CLP_ctr_cnt ^ CLP_ctr_cnt ^ expected_CLP_ctr_cnt) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: CLP_ctr_cnt=%h, state=%b",
                         CLP_ctr_cnt, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CLP_ctr_cnt=%h, state=%b",
                         expected_CLP_ctr_cnt, expected_state);
                $display("  Got:      CLP_ctr_cnt=%h, state=%b",
                         CLP_ctr_cnt, state);
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
        $dumpvars(0,CLP_work_time, clk, enable, rst, CLP_ctr_cnt, state);
    end

endmodule
