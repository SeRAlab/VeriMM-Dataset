`timescale 1ns/1ps

module lzw_compressor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg data_valid;
    reg rst;
    wire [15:0] compressed_out;
    wire out_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lzw_compressor dut (
        .clk(clk),
        .data_in(data_in),
        .data_valid(data_valid),
        .rst(rst),
        .compressed_out(compressed_out),
        .out_valid(out_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 8'h0;
            data_valid = 0;
            repeat(5) @(posedge clk);
            rst = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task wait_for_output;

        input [15:0] expected_val;
        begin
            while (!out_valid) @(posedge clk);
            #1;

            check_outputs(expected_val, 1'b1);
            @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTest Case %0d: Single Byte (0x41)", test_num);

            @(posedge clk);
            data_in = 8'h41;
            data_valid = 1;
            @(posedge clk);
            data_valid = 0;

            wait_for_output(16'h0041);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTest Case %0d: Sequence ABAB", test_num);


            @(posedge clk);
            data_in = 8'h41; data_valid = 1;
            @(posedge clk);


            data_in = 8'h42;
            @(posedge clk);


            data_in = 8'h41;
            @(posedge clk);


            data_in = 8'h42;
            @(posedge clk);

            data_valid = 0;


            wait_for_output(16'h0100);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTest Case %0d: Literal Run AAA", test_num);

            @(posedge clk);
            data_in = 8'h41; data_valid = 1;
            @(posedge clk);
            data_in = 8'h41;
            @(posedge clk);
            data_in = 8'h41;
            @(posedge clk);
            data_valid = 0;


            wait_for_output(16'h0100);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTest Case %0d: Reset Verification (BBB)", test_num);

            @(posedge clk);
            data_in = 8'h42; data_valid = 1;
            @(posedge clk);
            data_in = 8'h42;
            @(posedge clk);
            data_in = 8'h42;
            @(posedge clk);
            data_valid = 0;


            wait_for_output(16'h0100);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("lzw_compressor Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [15:0] expected_compressed_out;
        input expected_out_valid;
        begin
            if (expected_compressed_out === (expected_compressed_out ^ compressed_out ^ expected_compressed_out) &&
                expected_out_valid === (expected_out_valid ^ out_valid ^ expected_out_valid)) begin
                $display("PASS");
                $display("  Outputs: compressed_out=%h, out_valid=%b",
                         compressed_out, out_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: compressed_out=%h, out_valid=%b",
                         expected_compressed_out, expected_out_valid);
                $display("  Got:      compressed_out=%h, out_valid=%b",
                         compressed_out, out_valid);
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
        $dumpvars(0,clk, data_in, data_valid, rst, compressed_out, out_valid);
    end

endmodule
