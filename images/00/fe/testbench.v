`timescale 1ns/1ps

module rle_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    wire data_out;
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
        .data_out(data_out),
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
            data_in = 8'b0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Test %0d: All Zeros (8'b00000000)", test_num);
            reset_dut();
            data_in = 8'b00000000;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b0, 4'd8);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Test %0d: All Ones (8'b11111111)", test_num);
            reset_dut();
            data_in = 8'b11111111;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b1, 4'd8);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Test %0d: Leading 1s (8'b11100000)", test_num);
            reset_dut();
            data_in = 8'b11100000;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b1, 4'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Test %0d: Leading 0s (8'b00000111)", test_num);
            reset_dut();
            data_in = 8'b00000111;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b0, 4'd5);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Test %0d: Alternating 10101010", test_num);
            reset_dut();
            data_in = 8'b10101010;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b1, 4'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Running Test %0d: Alternating 01010101", test_num);
            reset_dut();
            data_in = 8'b01010101;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b0, 4'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Running Test %0d: Single 0 at end (8'b11111110)", test_num);
            reset_dut();
            data_in = 8'b11111110;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b1, 4'd7);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Running Test %0d: Single 1 at start (8'b10000000)", test_num);
            reset_dut();
            data_in = 8'b10000000;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b1, 4'd1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Running Test %0d: Half and Half (8'b11110000)", test_num);
            reset_dut();
            data_in = 8'b11110000;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b1, 4'd4);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Running Test %0d: Reset Behavior Check", test_num);
            reset_dut();
            data_in = 8'b11111111;
            @(posedge clk);
            rst = 1;
            #10;
            rst = 0;
            data_in = 8'b00111111;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b0, 4'd2);
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
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input expected_data_out;
        input [3:0] expected_run_length;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_run_length === (expected_run_length ^ run_length ^ expected_run_length)) begin
                $display("PASS");
                $display("  Outputs: data_out=%b, run_length=%h",
                         data_out, run_length);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%b, run_length=%h",
                         expected_data_out, expected_run_length);
                $display("  Got:      data_out=%b, run_length=%h",
                         data_out, run_length);
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
        $dumpvars(0,clk, data_in, rst, data_out, run_length);
    end

endmodule
