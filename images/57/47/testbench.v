`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [8:0] data;
    reg [3:0] data_len;
    reg rst_n;
    reg trans_start;
    wire output_data;
    wire output_done;
    wire output_start;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .data_len(data_len),
        .rst_n(rst_n),
        .trans_start(trans_start),
        .output_data(output_data),
        .output_done(output_done),
        .output_start(output_start)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            trans_start = 0;
            data = 0;
            data_len = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Running Testcase%03d: 9-bit All 1s", test_num);

            data = 9'b1_1111_1111;
            data_len = 4'd9;
            @(posedge clk);
            #1 trans_start = 1;
            @(posedge clk);
            #1 trans_start = 0;

            wait(output_done == 1'b1);
            #1;

            #1;


            check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Running Testcase%03d: 9-bit All 0s", test_num);

            data = 9'b0_0000_0000;
            data_len = 4'd9;
            @(posedge clk);
            #1 trans_start = 1;
            @(posedge clk);
            #1 trans_start = 0;

            wait(output_done == 1'b1);
            #1;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Running Testcase%03d: 4-bit Alternating 1010", test_num);

            data = 9'b0_0000_1010;
            data_len = 4'd4;
            @(posedge clk);
            #1 trans_start = 1;
            @(posedge clk);
            #1 trans_start = 0;

            wait(output_done == 1'b1);
            #1;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Running Testcase%03d: 1-bit High", test_num);

            data = 9'b0_0000_0001;
            data_len = 4'd1;
            @(posedge clk);
            #1 trans_start = 1;
            @(posedge clk);
            #1 trans_start = 0;

            wait(output_done == 1'b1);
            #1;
            #1;

            check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Running Testcase%03d: 6-bit Mixed", test_num);

            data = 9'b0_0011_0111;
            data_len = 4'd6;
            @(posedge clk);
            #1 trans_start = 1;
            @(posedge clk);
            #1 trans_start = 0;

            wait(output_done == 1'b1);
            #1;
            #1;

            check_outputs(1'b1, 1'b1, 1'b0);
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
        input expected_output_data;
        input expected_output_done;
        input expected_output_start;
        begin
            if (expected_output_data === (expected_output_data ^ output_data ^ expected_output_data) &&
                expected_output_done === (expected_output_done ^ output_done ^ expected_output_done) &&
                expected_output_start === (expected_output_start ^ output_start ^ expected_output_start)) begin
                $display("PASS");
                $display("  Outputs: output_data=%b, output_done=%b, output_start=%b",
                         output_data, output_done, output_start);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_data=%b, output_done=%b, output_start=%b",
                         expected_output_data, expected_output_done, expected_output_start);
                $display("  Got:      output_data=%b, output_done=%b, output_start=%b",
                         output_data, output_done, output_start);
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
        $dumpvars(0,clk, data, data_len, rst_n, trans_start, output_data, output_done, output_start);
    end

endmodule
