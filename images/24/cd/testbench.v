`timescale 1ns/1ps

module LZW_Compressor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [7:0] symbol_in;
    wire [11:0] code_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LZW_Compressor dut (
        .clk(clk),
        .reset(reset),
        .symbol_in(symbol_in),
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
            symbol_in = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Simple Sequence A->B", test_num);
            reset_dut();

            symbol_in = 8'h41;
            @(posedge clk);
            #1;

            symbol_in = 8'h42;
            @(posedge clk);
            #1;

            #1;


            check_outputs(12'h041, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Dictionary Hit (AA)", test_num);
            reset_dut();

            symbol_in = 8'h41;
            @(posedge clk);
            #1;

            symbol_in = 8'h41;
            @(posedge clk);
            #1;

            symbol_in = 8'h41;
            @(posedge clk);
            #1;

            symbol_in = 8'h42;
            @(posedge clk);
            #1;

            #1;


            check_outputs(12'h100, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Pattern ABAB", test_num);
            reset_dut();

            symbol_in = 8'h41;
            @(posedge clk); #1;
            symbol_in = 8'h42;
            @(posedge clk); #1;
            symbol_in = 8'h41;
            @(posedge clk); #1;
            symbol_in = 8'h42;
            @(posedge clk); #1;
            symbol_in = 8'h43;
            @(posedge clk); #1;

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
        $display("LZW_Compressor Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        
        
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
        $dumpvars(0,clk, reset, symbol_in, code_out, valid);
    end

endmodule
