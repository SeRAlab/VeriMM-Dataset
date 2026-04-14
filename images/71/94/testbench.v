`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg rst;
    reg ss_in;
    wire data_out;
    wire ss_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .ss_in(ss_in),
        .data_out(data_out),
        .ss_out(ss_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            ss_in = 1;
            data_in = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase %03d: Basic 8-bit transaction", test_num);
            reset_dut();
            @(negedge clk);
            ss_in = 0;
            repeat(8) begin
                data_in = $random % 2;
                @(posedge clk);
            end
            #2;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase %03d: IDLE state persistence", test_num);
            reset_dut();
            repeat(5) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase %03d: Active state verification", test_num);
            reset_dut();
            @(negedge clk);
            ss_in = 0;
            repeat(4) @(posedge clk);
            #2;

            #1;


            check_outputs(data_out, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase %03d: Reset mid-transaction", test_num);
            reset_dut();
            @(negedge clk);
            ss_in = 0;
            repeat(4) @(posedge clk);
            rst = 1;
            #11;
            rst = 0;
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase %03d: Consecutive transactions", test_num);
            reset_dut();


            @(negedge clk) ss_in = 0;
            repeat(8) @(posedge clk);
            @(negedge clk) ss_in = 1;


            repeat(2) @(posedge clk);


            @(negedge clk) ss_in = 0;
            repeat(8) @(posedge clk);
            @(negedge clk) ss_in = 1;

            #2;
            #1;

            check_outputs(1'b0, 1'b1);
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
        input expected_data_out;
        input expected_ss_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_ss_out === (expected_ss_out ^ ss_out ^ expected_ss_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%b, ss_out=%b",
                         data_out, ss_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%b, ss_out=%b",
                         expected_data_out, expected_ss_out);
                $display("  Got:      data_out=%b, ss_out=%b",
                         data_out, ss_out);
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
        $dumpvars(0,clk, data_in, rst, ss_in, data_out, ss_out);
    end

endmodule
