`timescale 1ns/1ps

module rle_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg rst;
    wire bit_out;
    wire [3:0] length;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rle_encoder dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .bit_out(bit_out),
        .length(length),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 0;
            #(10);
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            $display("DUT Reset Complete");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Run of three 1s", test_num);
            reset_dut();


            @(posedge clk); data_in = 1;
            @(posedge clk); data_in = 1;
            @(posedge clk); data_in = 1;


            @(posedge clk); data_in = 0;


            @(negedge clk);
            #1;

            check_outputs(1'b1, 4'd3, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Run of five 0s", test_num);
            reset_dut();


            @(posedge clk); data_in = 0;
            @(posedge clk); data_in = 0;
            @(posedge clk); data_in = 0;
            @(posedge clk); data_in = 0;
            @(posedge clk); data_in = 0;


            @(posedge clk); data_in = 1;


            @(negedge clk);
            #1;

            check_outputs(1'b0, 4'd5, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single bit run (Length 1)", test_num);
            reset_dut();


            @(posedge clk); data_in = 1;


            @(posedge clk); data_in = 0;


            @(negedge clk);
            #1;

            check_outputs(1'b1, 4'd1, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Maximum length run (15 bits)", test_num);
            reset_dut();


            for (i = 0; i < 15; i = i + 1) begin
                @(posedge clk); data_in = 1;
            end


            @(posedge clk); data_in = 0;

            @(negedge clk);
            #1;

            check_outputs(1'b1, 4'd15, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiple consecutive runs", test_num);
            reset_dut();


            @(posedge clk); data_in = 1;
            @(posedge clk); data_in = 1;


            @(posedge clk); data_in = 0;
            @(negedge clk);

            if (valid && length == 2 && bit_out == 1) $display("  Intermediate Run 1: PASS");
            else $display("  Intermediate Run 1: FAIL");


            @(posedge clk); data_in = 0;
            @(posedge clk); data_in = 0;
            @(posedge clk); data_in = 0;


            @(posedge clk); data_in = 1;

            @(negedge clk);
            #1;

            check_outputs(1'b0, 4'd4, 1'b1);
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
        input [3:0] expected_length;
        input expected_valid;
        begin
            if (expected_bit_out === (expected_bit_out ^ bit_out ^ expected_bit_out) &&
                expected_length === (expected_length ^ length ^ expected_length) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: bit_out=%b, length=%h, valid=%b",
                         bit_out, length, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bit_out=%b, length=%h, valid=%b",
                         expected_bit_out, expected_length, expected_valid);
                $display("  Got:      bit_out=%b, length=%h, valid=%b",
                         bit_out, length, valid);
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
        $dumpvars(0,clk, data_in, rst, bit_out, length, valid);
    end

endmodule
