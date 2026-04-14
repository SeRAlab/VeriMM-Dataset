`timescale 1ns/1ps

module RLE_Encoder_tb;

    // Testbench signals (sequential circuit)
    reg bit_in;
    reg clk;
    reg rst;
    wire [7:0] count;
    wire valid;
    wire value_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    RLE_Encoder dut (
        .bit_in(bit_in),
        .clk(clk),
        .rst(rst),
        .count(count),
        .valid(valid),
        .value_out(value_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            bit_in = 0;
            #10;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Run of four 0s (00001)");
            test_num = test_num + 1;
            reset_dut();


            @(posedge clk) bit_in = 0;
            @(posedge clk) bit_in = 0;
            @(posedge clk) bit_in = 0;
            @(posedge clk) bit_in = 0;


            @(posedge clk) bit_in = 1;


            @(negedge clk);
            #1;

            check_outputs(8'd4, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Run of five 1s (111110)");
            test_num = test_num + 1;
            reset_dut();


            @(posedge clk) bit_in = 1;
            @(posedge clk) bit_in = 1;
            @(posedge clk) bit_in = 1;
            @(posedge clk) bit_in = 1;
            @(posedge clk) bit_in = 1;


            @(posedge clk) bit_in = 0;

            @(negedge clk);
            #1;

            check_outputs(8'd5, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Single bit run (01)");
            test_num = test_num + 1;
            reset_dut();

            @(posedge clk) bit_in = 0;
            @(posedge clk) bit_in = 1;

            @(negedge clk);
            #1;

            check_outputs(8'd1, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Single bit run (10)");
            test_num = test_num + 1;
            reset_dut();

            @(posedge clk) bit_in = 1;
            @(posedge clk) bit_in = 0;

            @(negedge clk);
            #1;

            check_outputs(8'd1, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Spec example 0000111100 followed by 1");
            test_num = test_num + 1;
            reset_dut();


            repeat(4) @(posedge clk) bit_in = 0;


            @(posedge clk) bit_in = 1;
            repeat(3) @(posedge clk) bit_in = 1;


            @(posedge clk) bit_in = 0;
            repeat(1) @(posedge clk) bit_in = 0;


            @(posedge clk) bit_in = 1;

            @(negedge clk);
            #1;

            check_outputs(8'd2, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: Run of twelve 1s");
            test_num = test_num + 1;
            reset_dut();

            repeat(12) @(posedge clk) bit_in = 1;
            @(posedge clk) bit_in = 0;

            @(negedge clk);
            #1;

            check_outputs(8'd12, 1'b1, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("RLE_Encoder Testbench");
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
        input [7:0] expected_count;
        input expected_valid;
        input expected_value_out;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid) &&
                expected_value_out === (expected_value_out ^ value_out ^ expected_value_out)) begin
                $display("PASS");
                $display("  Outputs: count=%h, valid=%b, value_out=%b",
                         count, valid, value_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, valid=%b, value_out=%b",
                         expected_count, expected_valid, expected_value_out);
                $display("  Got:      count=%h, valid=%b, value_out=%b",
                         count, valid, value_out);
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
        $dumpvars(0,bit_in, clk, rst, count, valid, value_out);
    end

endmodule
