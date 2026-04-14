`timescale 1ns/1ps

module RLE_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] data_in;
    reg reset;
    wire [63:0] run_length_out;
    wire valid;
    wire [63:0] value_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    RLE dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .run_length_out(run_length_out),
        .valid(valid),
        .value_out(value_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 64'h0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros (64-bit run)", test_num);
            reset_dut();
            data_in = 64'h0000000000000000;
            repeat(64) @(posedge clk);
            #1 #1;
 check_outputs(64'd64, 1'b1, 64'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones (64-bit run)", test_num);
            reset_dut();
            data_in = 64'hFFFFFFFFFFFFFFFF;
            repeat(64) @(posedge clk);
            #1 #1;
 check_outputs(64'd64, 1'b1, 64'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 32 Zeros then 32 Ones", test_num);
            reset_dut();
            data_in = {32'h00000000, 32'hFFFFFFFF};
            repeat(64) @(posedge clk);
            #1 #1;
 check_outputs(64'd32, 1'b1, 64'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits (1010...)", test_num);
            reset_dut();
            data_in = 64'hAAAAAAAAAAAAAAAA;
            repeat(64) @(posedge clk);
            #1 #1;
 check_outputs(64'd1, 1'b1, 64'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 000111 followed by zeros", test_num);
            reset_dut();
            data_in = {3'b000, 3'b111, 58'b0};
            repeat(64) @(posedge clk);
            #1 #1;
 check_outputs(64'd58, 1'b1, 64'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 63 Ones followed by 1 Zero", test_num);
            reset_dut();
            data_in = 64'hFFFFFFFFFFFFFFFE;
            repeat(64) @(posedge clk);
            #1 #1;
 check_outputs(64'd1, 1'b1, 64'd0);
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
        input [63:0] expected_run_length_out;
        input expected_valid;
        input [63:0] expected_value_out;
        begin
            if (expected_run_length_out === (expected_run_length_out ^ run_length_out ^ expected_run_length_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid) &&
                expected_value_out === (expected_value_out ^ value_out ^ expected_value_out)) begin
                $display("PASS");
                $display("  Outputs: run_length_out=%h, valid=%b, value_out=%h",
                         run_length_out, valid, value_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: run_length_out=%h, valid=%b, value_out=%h",
                         expected_run_length_out, expected_valid, expected_value_out);
                $display("  Got:      run_length_out=%h, valid=%b, value_out=%h",
                         run_length_out, valid, value_out);
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
        $dumpvars(0,clk, data_in, reset, run_length_out, valid, value_out);
    end

endmodule
