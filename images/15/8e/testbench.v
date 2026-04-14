`timescale 1ns/1ps

module rle_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] data_in;
    reg rst;
    wire [15:0] encoded_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rle_encoder dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .encoded_out(encoded_out),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        data_in = 5'b0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case 001: All Zeros (00000)");
        reset_dut();
        data_in = 5'b00000;
        wait(valid === 1'b1);
        #1;

        check_outputs(16'h5000, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case 002: All Ones (11111)");
        reset_dut();
        data_in = 5'b11111;
        wait(valid === 1'b1);
        #1;

        check_outputs(16'h5100, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case 003: Example (00011)");
        reset_dut();
        data_in = 5'b00011;
        wait(valid === 1'b1);
        #1;

        check_outputs(16'h3021, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case 004: Inverted Example (11100)");
        reset_dut();
        data_in = 5'b11100;
        wait(valid === 1'b1);
        #1;

        check_outputs(16'h3120, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case 005: Single One at End (00001)");
        reset_dut();
        data_in = 5'b00001;
        wait(valid === 1'b1);
        #1;

        check_outputs(16'h4011, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case 006: Single One at Start (10000)");
        reset_dut();
        data_in = 5'b10000;
        wait(valid === 1'b1);
        #1;

        check_outputs(16'h1140, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case 007: Single Zero at Start (01111)");
        reset_dut();
        data_in = 5'b01111;
        wait(valid === 1'b1);
        #1;

        check_outputs(16'h1041, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case 008: Middle Transition (00111)");
        reset_dut();
        data_in = 5'b00111;
        wait(valid === 1'b1);
        #1;

        check_outputs(16'h2031, 1'b1);
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
        input [15:0] expected_encoded_out;
        input expected_valid;
        begin
            if (expected_encoded_out === (expected_encoded_out ^ encoded_out ^ expected_encoded_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: encoded_out=%h, valid=%b",
                         encoded_out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encoded_out=%h, valid=%b",
                         expected_encoded_out, expected_valid);
                $display("  Got:      encoded_out=%h, valid=%b",
                         encoded_out, valid);
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
        $dumpvars(0,clk, data_in, rst, encoded_out, valid);
    end

endmodule
