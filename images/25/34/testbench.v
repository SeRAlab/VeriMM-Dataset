`timescale 1ns/1ps

module RLE_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data;
    reg reset;
    reg valid;
    wire bit_value;
    wire [7:0] count;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    RLE dut (
        .clk(clk),
        .data(data),
        .reset(reset),
        .valid(valid),
        .bit_value(bit_value),
        .count(count),
        .ready(ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            valid = 0;
            data = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Run of four 1s");
            test_num = 1;
            reset_dut();


            @(posedge clk);
            valid = 1; data = 1; @(posedge clk);
            valid = 1; data = 1; @(posedge clk);
            valid = 1; data = 1; @(posedge clk);
            valid = 1; data = 1;


            @(posedge clk);
            valid = 1; data = 0;


            #1 #1;
 check_outputs(1'b1, 8'd4, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Run of two 0s");
            test_num = 2;
            reset_dut();


            @(posedge clk);
            valid = 1; data = 0; @(posedge clk);
            valid = 1; data = 0;


            @(posedge clk);
            valid = 1; data = 1;

            #1 #1;
 check_outputs(1'b0, 8'd2, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Single bit run (Alternating)");
            test_num = 3;
            reset_dut();


            @(posedge clk);
            valid = 1; data = 1;


            @(posedge clk);
            valid = 1; data = 0;

            #1 #1;
 check_outputs(1'b1, 8'd1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Valid signal low during run");
            test_num = 4;
            reset_dut();


            @(posedge clk);
            valid = 1; data = 1; @(posedge clk);
            valid = 1; data = 1; @(posedge clk);
            valid = 0; data = 0; @(posedge clk);
            valid = 0; data = 1; @(posedge clk);
            valid = 1; data = 1;


            @(posedge clk);
            valid = 1; data = 0;


            #1 #1;
 check_outputs(1'b1, 8'd3, 1'b1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            $display("Testcase 005: Run of ten 0s");
            test_num = 5;
            reset_dut();

            @(posedge clk);
            valid = 1; data = 0;
            repeat(9) @(posedge clk);


            valid = 1; data = 1;
            @(posedge clk);

            #1 #1;
 check_outputs(1'b0, 8'd10, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("RLE Testbench");
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
        input expected_bit_value;
        input [7:0] expected_count;
        input expected_ready;
        begin
            if (expected_bit_value === (expected_bit_value ^ bit_value ^ expected_bit_value) &&
                expected_count === (expected_count ^ count ^ expected_count) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: bit_value=%b, count=%h, ready=%b",
                         bit_value, count, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bit_value=%b, count=%h, ready=%b",
                         expected_bit_value, expected_count, expected_ready);
                $display("  Got:      bit_value=%b, count=%h, ready=%b",
                         bit_value, count, ready);
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
        $dumpvars(0,clk, data, reset, valid, bit_value, count, ready);
    end

endmodule
