`timescale 1ns/1ps

module rle_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg enable;
    reg reset;
    wire [3:0] count_out;
    wire data_out;
    wire data_out_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rle_encoder dut (
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .reset(reset),
        .count_out(count_out),
        .data_out(data_out),
        .data_out_valid(data_out_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            data_in = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Run of three 1s", test_num);
            reset_dut();

            enable = 1;
            data_in = 1; @(posedge clk);
            data_in = 1; @(posedge clk);
            data_in = 1; @(posedge clk);

            data_in = 0; @(posedge clk);
            #1;
            #1;

            check_outputs(4'd3, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Run of two 0s", test_num);
            reset_dut();

            enable = 1;
            data_in = 0; @(posedge clk);
            data_in = 0; @(posedge clk);

            data_in = 1; @(posedge clk);
            #1;
            #1;

            check_outputs(4'd2, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Termination by Enable signal", test_num);
            reset_dut();

            enable = 1;
            data_in = 1; @(posedge clk);
            data_in = 1; @(posedge clk);
            data_in = 1; @(posedge clk);
            data_in = 1; @(posedge clk);

            enable = 0; @(posedge clk);
            #1;
            #1;

            check_outputs(4'd4, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Single bit run (Alternating)", test_num);
            reset_dut();

            enable = 1;
            data_in = 1; @(posedge clk);
            data_in = 0; @(posedge clk);
            #1;
            #1;

            check_outputs(4'd1, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("\nTestcase %0d: Maximum count (15)", test_num);
            reset_dut();

            enable = 1;
            for (i = 0; i < 15; i = i + 1) begin
                data_in = 1;
                @(posedge clk);
            end

            data_in = 0; @(posedge clk);
            #1;
            #1;

            check_outputs(4'd15, 1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Multiple consecutive runs", test_num);
            reset_dut();

            enable = 1;
            data_in = 1; @(posedge clk);
            data_in = 1; @(posedge clk);

            data_in = 0; @(posedge clk);
            data_in = 0; @(posedge clk);
            data_in = 0; @(posedge clk);

            enable = 0; @(posedge clk);
            #1;
            #1;

            check_outputs(4'd3, 1'b0, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rle_encoder Testbench");
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
        input [3:0] expected_count_out;
        input expected_data_out;
        input expected_data_out_valid;
        begin
            if (expected_count_out === (expected_count_out ^ count_out ^ expected_count_out) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_data_out_valid === (expected_data_out_valid ^ data_out_valid ^ expected_data_out_valid)) begin
                $display("PASS");
                $display("  Outputs: count_out=%h, data_out=%b, data_out_valid=%b",
                         count_out, data_out, data_out_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count_out=%h, data_out=%b, data_out_valid=%b",
                         expected_count_out, expected_data_out, expected_data_out_valid);
                $display("  Got:      count_out=%h, data_out=%b, data_out_valid=%b",
                         count_out, data_out, data_out_valid);
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
        $dumpvars(0,clk, data_in, enable, reset, count_out, data_out, data_out_valid);
    end

endmodule
