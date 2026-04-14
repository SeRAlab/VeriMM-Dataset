`timescale 1ns/1ps

module sample_rate_converter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] input_sample;
    reg rst_n;
    wire [7:0] output_sample;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sample_rate_converter dut (
        .clk(clk),
        .input_sample(input_sample),
        .rst_n(rst_n),
        .output_sample(output_sample),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            input_sample = 0;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Basic Averaging (10, 20)", test_num);
            reset_dut();
            input_sample = 8'd10;
            @(posedge clk);
            input_sample = 8'd20;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd15, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Max Values (255, 255)", test_num);
            reset_dut();
            input_sample = 8'd255;
            @(posedge clk);
            input_sample = 8'd255;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd255, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Zero Values (0, 0)", test_num);
            reset_dut();
            input_sample = 8'd0;
            @(posedge clk);
            input_sample = 8'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Odd Sum Truncation (10, 11)", test_num);
            reset_dut();
            input_sample = 8'd10;
            @(posedge clk);
            input_sample = 8'd11;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd10, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Large Odd Sum (255, 0)", test_num);
            reset_dut();
            input_sample = 8'd255;
            @(posedge clk);
            input_sample = 8'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd127, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Alternating Values (128, 64)", test_num);
            reset_dut();
            input_sample = 8'd128;
            @(posedge clk);
            input_sample = 8'd64;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd96, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sample_rate_converter Testbench");
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
        input [7:0] expected_output_sample;
        input expected_valid;
        begin
            if (expected_output_sample === (expected_output_sample ^ output_sample ^ expected_output_sample) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: output_sample=%h, valid=%b",
                         output_sample, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_sample=%h, valid=%b",
                         expected_output_sample, expected_valid);
                $display("  Got:      output_sample=%h, valid=%b",
                         output_sample, valid);
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
        $dumpvars(0,clk, input_sample, rst_n, output_sample, valid);
    end

endmodule
