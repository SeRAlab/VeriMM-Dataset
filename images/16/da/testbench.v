`timescale 1ns/1ps

module rle_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg rst;
    wire [1:0] encoded_value;
    wire [3:0] run_length;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rle_encoder dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .encoded_value(encoded_value),
        .run_length(run_length)
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
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Run of 5 Zeros", test_num);
            reset_dut();
            repeat(5) @(posedge clk) data_in = 0;
            @(negedge clk);
            #1;

            check_outputs(2'b00, 4'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Run of 12 Ones", test_num);
            reset_dut();
            repeat(12) @(posedge clk) data_in = 1;
            @(negedge clk);
            #1;

            check_outputs(2'b01, 4'd12);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Zero", test_num);
            reset_dut();
            @(posedge clk) data_in = 0;
            @(negedge clk);
            #1;

            check_outputs(2'b00, 4'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Transition (2 Zeros followed by 3 Ones)", test_num);
            reset_dut();
            repeat(2) @(posedge clk) data_in = 0;
            repeat(3) @(posedge clk) data_in = 1;
            @(negedge clk);
            #1;

            check_outputs(2'b01, 4'd3);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Run Length (15 Zeros)", test_num);
            reset_dut();
            repeat(15) @(posedge clk) data_in = 0;
            @(negedge clk);
            #1;

            check_outputs(2'b00, 4'd15);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits (1-0-1)", test_num);
            reset_dut();
            @(posedge clk) data_in = 1;
            @(posedge clk) data_in = 0;
            @(posedge clk) data_in = 1;
            @(negedge clk);
            #1;

            check_outputs(2'b01, 4'd1);
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
        input [1:0] expected_encoded_value;
        input [3:0] expected_run_length;
        begin
            if (expected_encoded_value === (expected_encoded_value ^ encoded_value ^ expected_encoded_value) &&
                expected_run_length === (expected_run_length ^ run_length ^ expected_run_length)) begin
                $display("PASS");
                $display("  Outputs: encoded_value=%h, run_length=%h",
                         encoded_value, run_length);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encoded_value=%h, run_length=%h",
                         expected_encoded_value, expected_run_length);
                $display("  Got:      encoded_value=%h, run_length=%h",
                         encoded_value, run_length);
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
        $dumpvars(0,clk, data_in, rst, encoded_value, run_length);
    end

endmodule
