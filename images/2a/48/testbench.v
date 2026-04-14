`timescale 1ns/1ps

module lzw_compressor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    reg valid_in;
    wire [15:0] compressed_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lzw_compressor dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .valid_in(valid_in),
        .compressed_out(compressed_out),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            valid_in = 0;
            data_in = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task wait_for_valid;

        integer timeout;
        begin
            timeout = 0;
            while (!valid_out && timeout < 100) begin
                @(posedge clk);
                timeout = timeout + 1;
            end
        end
        endtask

    task testcase001;

        begin
            $display("Running Test Case 001: Literal Output ('A' then 'B')");
            reset_dut();


            data_in = 8'h41; valid_in = 1; @(posedge clk);


            data_in = 8'h42; valid_in = 1; @(posedge clk);
            valid_in = 0;

            wait_for_valid();
            #1;

            check_outputs(16'h0041, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running Test Case 002: Dictionary Match (Code 256)");
            reset_dut();


            data_in = 8'h41; valid_in = 1; @(posedge clk);

            data_in = 8'h42; valid_in = 1; @(posedge clk);

            data_in = 8'h41; valid_in = 1; @(posedge clk);

            data_in = 8'h42; valid_in = 1; @(posedge clk);

            data_in = 8'h43; valid_in = 1; @(posedge clk);
            valid_in = 0;



            repeat(1) wait_for_valid();
            #1;

            check_outputs(16'h0100, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running Test Case 003: Repeated Sequence (AA)");
            reset_dut();

            data_in = 8'h41; valid_in = 1; @(posedge clk);
            data_in = 8'h41; valid_in = 1; @(posedge clk);
            data_in = 8'h41; valid_in = 1; @(posedge clk);
            data_in = 8'h41; valid_in = 1; @(posedge clk);
            data_in = 8'h42; valid_in = 1; @(posedge clk);
            valid_in = 0;


            repeat(1) wait_for_valid();
            #1;

            check_outputs(16'h0041, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running Test Case 004: Non-repeating stream");
            reset_dut();

            data_in = 8'h01; valid_in = 1; @(posedge clk);
            data_in = 8'h02; valid_in = 1; @(posedge clk);
            data_in = 8'h03; valid_in = 1; @(posedge clk);
            data_in = 8'h04; valid_in = 1; @(posedge clk);
            valid_in = 0;

            repeat(1) wait_for_valid();

            #1;


            check_outputs(16'h0003, 1'b1);
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
        input expected_valid_out;
        begin
            if (expected_compressed_out === (expected_compressed_out ^ compressed_out ^ expected_compressed_out) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: compressed_out=%h, valid_out=%b",
                         compressed_out, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: compressed_out=%h, valid_out=%b",
                         expected_compressed_out, expected_valid_out);
                $display("  Got:      compressed_out=%h, valid_out=%b",
                         compressed_out, valid_out);
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
        $dumpvars(0,clk, data_in, rst, valid_in, compressed_out, valid_out);
    end

endmodule
