`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clk_cnt;
    reg cmd;
    reg slave_wait;
    wire cmd_stop;
    wire [15:0] cnt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clk_cnt(clk_cnt),
        .cmd(cmd),
        .slave_wait(slave_wait),
        .cmd_stop(cmd_stop),
        .cnt(cnt)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            slave_wait = 0;
            clk_cnt = 0;
            cmd = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(1'b0, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            cmd = 1;
            slave_wait = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            cmd = 1;
            slave_wait = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            cmd = 1;
            clk_cnt = 1;
            @(posedge clk);
            #1;





            #1;






            check_outputs(1'b1, 16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            cmd = 1;
            slave_wait = 1;
            @(posedge clk);
            #1;
            slave_wait = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            cmd = 1;
            clk_cnt = 1;

            repeat (5) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 16'h0000);
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
        input expected_cmd_stop;
        input [15:0] expected_cnt;
        begin
            if (expected_cmd_stop === (expected_cmd_stop ^ cmd_stop ^ expected_cmd_stop) &&
                expected_cnt === (expected_cnt ^ cnt ^ expected_cnt)) begin
                $display("PASS");
                $display("  Outputs: cmd_stop=%b, cnt=%h",
                         cmd_stop, cnt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cmd_stop=%b, cnt=%h",
                         expected_cmd_stop, expected_cnt);
                $display("  Got:      cmd_stop=%b, cnt=%h",
                         cmd_stop, cnt);
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
        $dumpvars(0,clk, clk_cnt, cmd, slave_wait, cmd_stop, cnt);
    end

endmodule
