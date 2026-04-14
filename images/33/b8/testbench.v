`timescale 1ns/1ps

module pipeline_adder_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg rst_n;
    reg valid;
    wire ready;
    wire [8:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_adder dut (
        .a(a),
        .b(b),
        .clk(clk),
        .rst_n(rst_n),
        .valid(valid),
        .ready(ready),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            a = 0;
            b = 0;
            valid = 0;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case 001: Basic Addition (10 + 20)");
            a = 8'd10;
            b = 8'd20;
            valid = 1;
            @(posedge clk);
            valid = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 9'd30);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case 002: Maximum Values (255 + 255)");
            a = 8'd255;
            b = 8'd255;
            valid = 1;
            @(posedge clk);
            valid = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 9'd510);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case 003: Zero Addition (0 + 0)");
            a = 8'd0;
            b = 8'd0;
            valid = 1;
            @(posedge clk);
            valid = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 9'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case 004: Valid signal Low");
            a = 8'd50;
            b = 8'd50;
            valid = 0;
            @(posedge clk);
            repeat(2) @(posedge clk);
            #1;


            if (ready === 1'b0) begin
                $display("PASS: Ready is low as expected");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Ready is high despite valid being low");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case 005: Pipelined Burst (Checking last result)");


            a = 8'd1; b = 8'd1; valid = 1;
            @(posedge clk);


            a = 8'd100; b = 8'd50; valid = 1;
            @(posedge clk);


            valid = 0;
            @(posedge clk);

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 9'd150);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case 006: Reset mid-operation");
            a = 8'd20; b = 8'd20; valid = 1;
            @(posedge clk);
            rst_n = 0;
            @(posedge clk);
            rst_n = 1;
            repeat(2) @(posedge clk);
            #1;

            if (ready === 1'b0) begin
                $display("PASS: Ready is low after reset");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Ready is high after reset");
                fail_count = fail_count + 1;
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipeline_adder Testbench");
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
        input expected_ready;
        input [8:0] expected_sum;
        begin
            if (expected_ready === (expected_ready ^ ready ^ expected_ready) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: ready=%b, sum=%h",
                         ready, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ready=%b, sum=%h",
                         expected_ready, expected_sum);
                $display("  Got:      ready=%b, sum=%h",
                         ready, sum);
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
        $dumpvars(0,a, b, clk, rst_n, valid, ready, sum);
    end

endmodule
