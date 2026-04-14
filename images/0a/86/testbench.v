`timescale 1ns/1ps

module LZW_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] input_data;
    reg reset;
    reg valid_input;
    wire [15:0] compressed_output;
    wire output_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LZW dut (
        .clk(clk),
        .input_data(input_data),
        .reset(reset),
        .valid_input(valid_input),
        .compressed_output(compressed_output),
        .output_valid(output_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            input_data = 8'h0;
            valid_input = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Simple Unique Stream...");
            reset_dut();

            @(posedge clk);
            input_data = 8'h10; valid_input = 1;
            @(posedge clk);
            input_data = 8'h20; valid_input = 1;
            @(posedge clk);
            input_data = 8'h30; valid_input = 1;
            @(posedge clk);
            valid_input = 0;

            repeat(2) @(posedge clk);


            #1;



            check_outputs(16'h0020, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Repeated Byte (Pattern Match)...");
            reset_dut();

            @(posedge clk);
            input_data = 8'hAA; valid_input = 1;
            @(posedge clk);
            input_data = 8'hAA; valid_input = 1;
            @(posedge clk);
            input_data = 8'hAA; valid_input = 1;
            @(posedge clk);
            input_data = 8'hBB; valid_input = 1;
            @(posedge clk);
            valid_input = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'h0100, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Repeated Sequence (ABAB)...");
            reset_dut();

            @(posedge clk);
            input_data = 8'h11; valid_input = 1;
            @(posedge clk);
            input_data = 8'h22; valid_input = 1;
            @(posedge clk);
            input_data = 8'h11; valid_input = 1;
            @(posedge clk);
            input_data = 8'h22; valid_input = 1;
            @(posedge clk);
            input_data = 8'h33; valid_input = 1;
            @(posedge clk);
            valid_input = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'h0100, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Unique Stream Final Check...");
            reset_dut();

            @(posedge clk);
            input_data = 8'h01; valid_input = 1;
            @(posedge clk);
            input_data = 8'h02; valid_input = 1;
            @(posedge clk);
            input_data = 8'h03; valid_input = 1;
            @(posedge clk);
            input_data = 8'h04; valid_input = 1;
            @(posedge clk);
            valid_input = 0;

            repeat(2) @(posedge clk);
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
        $display("LZW Testbench");
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
        input [15:0] expected_compressed_output;
        input expected_output_valid;
        begin
            if (expected_compressed_output === (expected_compressed_output ^ compressed_output ^ expected_compressed_output) &&
                expected_output_valid === (expected_output_valid ^ output_valid ^ expected_output_valid)) begin
                $display("PASS");
                $display("  Outputs: compressed_output=%h, output_valid=%b",
                         compressed_output, output_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: compressed_output=%h, output_valid=%b",
                         expected_compressed_output, expected_output_valid);
                $display("  Got:      compressed_output=%h, output_valid=%b",
                         compressed_output, output_valid);
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
        $dumpvars(0,clk, input_data, reset, valid_input, compressed_output, output_valid);
    end

endmodule
