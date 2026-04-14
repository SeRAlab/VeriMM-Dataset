`timescale 1ns/1ps

module pipeline_adder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] input_a;
    reg [7:0] input_b;
    reg reset;
    wire [7:0] output_sum;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_adder dut (
        .clk(clk),
        .input_a(input_a),
        .input_b(input_b),
        .reset(reset),
        .output_sum(output_sum),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            input_a = 0;
            input_b = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Test Case 001: Basic Addition (15 + 25)");
            reset_dut();
            test_num = 1;
            input_a = 8'd15;
            input_b = 8'd25;
            @(posedge clk);

            input_a = 8'd0;
            input_b = 8'd0;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd40, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Adding Zeros (0 + 0)");
            reset_dut();
            test_num = 2;
            input_a = 8'd0;
            input_b = 8'd0;
            @(posedge clk);
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Boundary Value (255 + 0)");
            reset_dut();
            test_num = 3;
            input_a = 8'd255;
            input_b = 8'd0;
            @(posedge clk);
            input_a = 8'd0;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd255, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Overflow Wrap-around (200 + 100)");
            reset_dut();
            test_num = 4;
            input_a = 8'd200;
            input_b = 8'd100;
            @(posedge clk);
            input_a = 8'd0;
            input_b = 8'd0;
            repeat(4) @(posedge clk);
            #1;

            #1;


            check_outputs(8'd44, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Power of Two (128 + 64)");
            reset_dut();
            test_num = 5;
            input_a = 8'd128;
            input_b = 8'd64;
            @(posedge clk);
            input_a = 8'd0;
            input_b = 8'd0;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd192, 1'b1);
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
        input [7:0] expected_output_sum;
        input expected_valid;
        begin
            if (expected_output_sum === (expected_output_sum ^ output_sum ^ expected_output_sum) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: output_sum=%h, valid=%b",
                         output_sum, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_sum=%h, valid=%b",
                         expected_output_sum, expected_valid);
                $display("  Got:      output_sum=%h, valid=%b",
                         output_sum, valid);
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
        $dumpvars(0,clk, input_a, input_b, reset, output_sum, valid);
    end

endmodule
