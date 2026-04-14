`timescale 1ns/1ps

module LZW_Compression_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    wire [11:0] code_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LZW_Compression dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .code_out(code_out),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 8'h0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Literal Emission ('A' -> 'B')...");
            reset_dut();
            test_num = 1;

            data_in = 8'h41;
            @(posedge clk);
            data_in = 8'h42;
            @(posedge clk);

            #1;


            check_outputs(12'h041, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Dictionary Hit (Compressed Sequence)...");
            reset_dut();
            test_num = 2;

            data_in = 8'h41; @(posedge clk);
            data_in = 8'h42; @(posedge clk);
            data_in = 8'h41; @(posedge clk);
            data_in = 8'h42; @(posedge clk);
            data_in = 8'h43; @(posedge clk);

            #1;


            check_outputs(12'h100, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Sequential Literals...");
            reset_dut();
            test_num = 3;

            data_in = 8'h01; @(posedge clk);
            data_in = 8'h02; @(posedge clk);
            data_in = 8'h03; @(posedge clk);

            #1;


            check_outputs(12'h002, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Zero Sequence...");
            reset_dut();
            test_num = 4;

            data_in = 8'h00; @(posedge clk);
            data_in = 8'h00; @(posedge clk);
            data_in = 8'h00; @(posedge clk);
            data_in = 8'h01; @(posedge clk);

            #1;


            check_outputs(12'h100, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LZW_Compression Testbench");
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
        input [11:0] expected_code_out;
        input expected_valid;
        begin
            if (expected_code_out === (expected_code_out ^ code_out ^ expected_code_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: code_out=%h, valid=%b",
                         code_out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: code_out=%h, valid=%b",
                         expected_code_out, expected_valid);
                $display("  Got:      code_out=%h, valid=%b",
                         code_out, valid);
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
        $dumpvars(0,clk, data_in, reset, code_out, valid);
    end

endmodule
