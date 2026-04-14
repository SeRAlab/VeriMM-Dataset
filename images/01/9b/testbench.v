`timescale 1ns/1ps

module LZW_FSM_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] char_in;
    reg clk;
    reg reset;
    wire [11:0] code_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LZW_FSM dut (
        .char_in(char_in),
        .clk(clk),
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
            char_in = 8'h0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
            $display("DUT Reset Complete");
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Input 'A' (0x41), then 'B' (0x42)");
            test_num = test_num + 1;
            reset_dut();

            @(negedge clk) char_in = 8'h41;
            @(negedge clk) char_in = 8'h42;

            @(posedge clk);
            #1;
            #1;

            check_outputs(12'h041, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Input 'B' (0x42), then 'A' (0x41)");
            test_num = test_num + 1;
            reset_dut();

            @(negedge clk) char_in = 8'h42;
            @(negedge clk) char_in = 8'h41;

            @(posedge clk);
            #1;
            #1;

            check_outputs(12'h042, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Sequence 'A','B','A','B','C' -> Expecting code 0x100");
            test_num = test_num + 1;
            reset_dut();

            @(negedge clk) char_in = 8'h41;
            @(negedge clk) char_in = 8'h42;
            @(negedge clk) char_in = 8'h41;
            @(negedge clk) char_in = 8'h42;
            @(negedge clk) char_in = 8'h43;

            @(posedge clk);
            #1;
            #1;

            check_outputs(12'h100, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Sequence 'A','A','A','A','B' -> Expecting code 0x100");
            test_num = test_num + 1;
            reset_dut();

            @(negedge clk) char_in = 8'h41;
            @(negedge clk) char_in = 8'h41;
            @(negedge clk) char_in = 8'h41;
            @(negedge clk) char_in = 8'h41;
            @(negedge clk) char_in = 8'h42;

            @(posedge clk);
            #1;
            #1;

            check_outputs(12'h100, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Multi-step 'ABCABC' -> Checking final dictionary emission");
            test_num = test_num + 1;
            reset_dut();

            @(negedge clk) char_in = 8'h41;
            @(negedge clk) char_in = 8'h42;
            @(negedge clk) char_in = 8'h43;
            @(negedge clk) char_in = 8'h41;
            @(negedge clk) char_in = 8'h42;
            @(negedge clk) char_in = 8'h43;

            @(posedge clk);
            #1;
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
        $display("LZW_FSM Testbench");
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
        $dumpvars(0,char_in, clk, reset, code_out, valid);
    end

endmodule
