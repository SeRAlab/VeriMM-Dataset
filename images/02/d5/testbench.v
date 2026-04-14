`timescale 1ns/1ps

module rle_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg data_valid;
    reg rst;
    wire [7:0] count;
    wire valid_out;
    wire value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rle_encoder dut (
        .clk(clk),
        .data_in(data_in),
        .data_valid(data_valid),
        .rst(rst),
        .count(count),
        .valid_out(valid_out),
        .value(value)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 8'h0;
            data_valid = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %03d: Run of 8 zeros", test_num);
            data_in = 8'b00000000;
            data_valid = 1;
            @(posedge clk);

            data_in = 8'b11111111;
            @(posedge clk);
            data_valid = 0;
            wait(valid_out);
            #1;

            check_outputs(8'd8, 1'b1, 1'b0);
            @(posedge clk);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %03d: Run of 8 ones", test_num);
            data_in = 8'b11111111;
            data_valid = 1;
            @(posedge clk);

            data_in = 8'b00000000;
            @(posedge clk);
            data_valid = 0;
            wait(valid_out);
            #1;

            check_outputs(8'd8, 1'b1, 1'b1);
            @(posedge clk);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %03d: Run of 16 zeros across two bytes", test_num);
            data_in = 8'h00; data_valid = 1;
            @(posedge clk);
            data_in = 8'h00;
            @(posedge clk);
            data_in = 8'hFF;
            @(posedge clk);
            data_valid = 0;
            wait(valid_out);
            #1;

            check_outputs(8'd16, 1'b1, 1'b0);
            @(posedge clk);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %03d: Run of 4 ones (within 0xF0)", test_num);
            data_in = 8'b11110000;
            data_valid = 1;
            @(posedge clk);
            data_valid = 0;
            wait(valid_out);

            #1;


            check_outputs(8'd4, 1'b1, 1'b1);
            @(posedge clk);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %03d: Minimal run length of 1 bit", test_num);
            data_in = 8'b01111111;
            data_valid = 1;
            @(posedge clk);
            data_valid = 0;
            wait(valid_out);
            #1;

            check_outputs(8'd1, 1'b1, 1'b0);
            @(posedge clk);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %03d: Reset during operation", test_num);
            data_in = 8'h00; data_valid = 1;
            @(posedge clk);
            rst = 1; @(posedge clk); rst = 0;
            repeat(2) @(posedge clk);
            data_in = 8'hFF; data_valid = 1;
            @(posedge clk);
            data_in = 8'h00;
            @(posedge clk);
            data_valid = 0;
            wait(valid_out);
            #1;

            check_outputs(8'd8, 1'b1, 1'b1);
            @(posedge clk);
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
        input [7:0] expected_count;
        input expected_valid_out;
        input expected_value;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out) &&
                expected_value === (expected_value ^ value ^ expected_value)) begin
                $display("PASS");
                $display("  Outputs: count=%h, valid_out=%b, value=%b",
                         count, valid_out, value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, valid_out=%b, value=%b",
                         expected_count, expected_valid_out, expected_value);
                $display("  Got:      count=%h, valid_out=%b, value=%b",
                         count, valid_out, value);
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
        $dumpvars(0,clk, data_in, data_valid, rst, count, valid_out, value);
    end

endmodule
