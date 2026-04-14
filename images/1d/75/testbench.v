`timescale 1ns/1ps

module rle_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg rst;
    reg valid_in;
    wire bit_out;
    wire [3:0] run_length;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rle_encoder dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .valid_in(valid_in),
        .bit_out(bit_out),
        .run_length(run_length),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            valid_in = 0;
            data_in = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Run of three 0s followed by 1", test_num);
            reset_dut();

            valid_in = 1;
            data_in = 0;
            repeat(3) @(posedge clk);

            data_in = 1;
            @(posedge clk);

            valid_in = 0;
            #2;
            #1;

            check_outputs(1'b0, 4'd3, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Run of five 1s followed by 0", test_num);
            reset_dut();

            valid_in = 1;
            data_in = 1;
            repeat(5) @(posedge clk);

            data_in = 0;
            @(posedge clk);

            valid_in = 0;
            #2;
            #1;

            check_outputs(1'b1, 4'd5, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max run length (15 bits)", test_num);
            reset_dut();

            valid_in = 1;
            data_in = 1;
            repeat(15) @(posedge clk);

            @(posedge clk);
            valid_in = 0;
            #2;
            #1;

            check_outputs(1'b1, 4'd15, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single bit run (0 then 1)", test_num);
            reset_dut();

            valid_in = 1;
            data_in = 0;
            @(posedge clk);

            data_in = 1;
            @(posedge clk);

            valid_in = 0;
            #2;
            #1;

            check_outputs(1'b0, 4'd1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple runs (check second run)", test_num);
            reset_dut();

            valid_in = 1;
            data_in = 0;
            repeat(2) @(posedge clk);

            data_in = 1;
            @(posedge clk);

            repeat(2) @(posedge clk);

            data_in = 0;
            @(posedge clk);

            valid_in = 0;
            #2;
            #1;

            check_outputs(1'b1, 4'd3, 1'b1);
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
        input expected_bit_out;
        input [3:0] expected_run_length;
        input expected_valid_out;
        begin
            if (expected_bit_out === (expected_bit_out ^ bit_out ^ expected_bit_out) &&
                expected_run_length === (expected_run_length ^ run_length ^ expected_run_length) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: bit_out=%b, run_length=%h, valid_out=%b",
                         bit_out, run_length, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bit_out=%b, run_length=%h, valid_out=%b",
                         expected_bit_out, expected_run_length, expected_valid_out);
                $display("  Got:      bit_out=%b, run_length=%h, valid_out=%b",
                         bit_out, run_length, valid_out);
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
        $dumpvars(0,clk, data_in, rst, valid_in, bit_out, run_length, valid_out);
    end

endmodule
