`timescale 1ns/1ps

module RLE_Encoder_tb;

    // Testbench signals (sequential circuit)
    reg bit_in;
    reg clk;
    reg reset;
    reg start;
    wire bit_value;
    wire [7:0] run_length;
    wire valid_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    RLE_Encoder dut (
        .bit_in(bit_in),
        .clk(clk),
        .reset(reset),
        .start(start),
        .bit_value(bit_value),
        .run_length(run_length),
        .valid_output(valid_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start = 0;
            bit_in = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Running testcase%03d: Three 0s", test_num);
            @(posedge clk);
            #1 start = 1; bit_in = 0;
            repeat(3) @(posedge clk);
            #1 start = 0;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 8'd3, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Running testcase%03d: Five 1s", test_num);
            @(posedge clk);
            #1 start = 1; bit_in = 1;
            repeat(5) @(posedge clk);
            #1 start = 0;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 8'd5, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Running testcase%03d: Single 0", test_num);
            @(posedge clk);
            #1 start = 1; bit_in = 0;
            @(posedge clk);
            #1 start = 0;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 8'd1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Running testcase%03d: Single 1", test_num);
            @(posedge clk);
            #1 start = 1; bit_in = 1;
            @(posedge clk);
            #1 start = 0;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 8'd1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Running testcase%03d: Mixed run 00...111", test_num);
            @(posedge clk);
            #1 start = 1; bit_in = 0;
            repeat(2) @(posedge clk);
            #1 bit_in = 1;
            repeat(3) @(posedge clk);
            #1 start = 0;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 8'd3, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Running testcase%03d: Ten 1s", test_num);
            @(posedge clk);
            #1 start = 1; bit_in = 1;
            repeat(10) @(posedge clk);
            #1 start = 0;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 8'd10, 1'b1);
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
        input expected_bit_value;
        input [7:0] expected_run_length;
        input expected_valid_output;
        begin
            if (expected_bit_value === (expected_bit_value ^ bit_value ^ expected_bit_value) &&
                expected_run_length === (expected_run_length ^ run_length ^ expected_run_length) &&
                expected_valid_output === (expected_valid_output ^ valid_output ^ expected_valid_output)) begin
                $display("PASS");
                $display("  Outputs: bit_value=%b, run_length=%h, valid_output=%b",
                         bit_value, run_length, valid_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bit_value=%b, run_length=%h, valid_output=%b",
                         expected_bit_value, expected_run_length, expected_valid_output);
                $display("  Got:      bit_value=%b, run_length=%h, valid_output=%b",
                         bit_value, run_length, valid_output);
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
        $dumpvars(0,bit_in, clk, reset, start, bit_value, run_length, valid_output);
    end

endmodule
