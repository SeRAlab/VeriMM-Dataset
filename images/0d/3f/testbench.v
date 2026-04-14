`timescale 1ns/1ps

module rle_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg reset;
    reg start;
    wire [7:0] count;
    wire [7:0] encoded_value;
    wire valid_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rle_encoder dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .start(start),
        .count(count),
        .encoded_value(encoded_value),
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
            data_in = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %03d: Five 1s", test_num);
            reset_dut();

            repeat(5) begin
                data_in = 1;
                @(posedge clk);
            end

            start = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd5, 8'h01, 1'b1);
            start = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %03d: Three 0s", test_num);
            reset_dut();

            repeat(3) begin
                data_in = 0;
                @(posedge clk);
            end

            start = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd3, 8'h00, 1'b1);
            start = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %03d: Single bit (1)", test_num);
            reset_dut();

            data_in = 1;
            @(posedge clk);

            start = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd1, 8'h01, 1'b1);
            start = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %03d: Mixed stream (11100)", test_num);
            reset_dut();


            repeat(3) begin
                data_in = 1;
                @(posedge clk);
            end

            repeat(2) begin
                data_in = 0;
                @(posedge clk);
            end

            start = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'd2, 8'h00, 1'b1);
            start = 0;
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("Test Case %03d: Large count (128 zeros)", test_num);
            reset_dut();

            for (i = 0; i < 128; i = i + 1) begin
                data_in = 0;
                @(posedge clk);
            end

            start = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd128, 8'h00, 1'b1);
            start = 0;
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
        input [7:0] expected_count;
        input [7:0] expected_encoded_value;
        input expected_valid_output;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_encoded_value === (expected_encoded_value ^ encoded_value ^ expected_encoded_value) &&
                expected_valid_output === (expected_valid_output ^ valid_output ^ expected_valid_output)) begin
                $display("PASS");
                $display("  Outputs: count=%h, encoded_value=%h, valid_output=%b",
                         count, encoded_value, valid_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, encoded_value=%h, valid_output=%b",
                         expected_count, expected_encoded_value, expected_valid_output);
                $display("  Got:      count=%h, encoded_value=%h, valid_output=%b",
                         count, encoded_value, valid_output);
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
        $dumpvars(0,clk, data_in, reset, start, count, encoded_value, valid_output);
    end

endmodule
