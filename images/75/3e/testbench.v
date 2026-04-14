`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] data_in;
    reg [127:0] key;
    reg mode;
    reg reset;
    wire [127:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .key(key),
        .mode(mode),
        .reset(reset),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            data_in = 128'b0;
            key = 128'b0;
            mode = 0;
            @(negedge clk);
            reset = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: NIST AES-128 Encryption", test_num);
            reset_dut();
            mode = 1'b0;
            key = 128'h2b7e151628aed2a6abf7158809cf4f3c;
            data_in = 128'h6bc1bee22e409f96e93d7e117393172a;

            @(posedge clk);
            #1;
            #1;

            check_outputs(128'h3ad77bb40d7a3660a89ecaf32466ef97);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: NIST AES-128 Decryption", test_num);
            reset_dut();
            mode = 1'b1;
            key = 128'h2b7e151628aed2a6abf7158809cf4f3c;
            data_in = 128'h3ad77bb40d7a3660a89ecaf32466ef97;

            @(posedge clk);
            #1;
            #1;

            check_outputs(128'h6bc1bee22e409f96e93d7e117393172a);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros Encryption", test_num);
            reset_dut();
            mode = 1'b0;
            key = 128'h00000000000000000000000000000000;
            data_in = 128'h00000000000000000000000000000000;

            @(posedge clk);
            #1;
            #1;

            check_outputs(128'h66e94bd4ef8a2c3b884cfa59ca342b2e);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros Decryption", test_num);
            reset_dut();
            mode = 1'b1;
            key = 128'h00000000000000000000000000000000;
            data_in = 128'h66e94bd4ef8a2c3b884cfa59ca342b2e;

            @(posedge clk);
            #1;
            #1;

            check_outputs(128'h00000000000000000000000000000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High-entropy Key/Data Encryption", test_num);
            reset_dut();
            mode = 1'b0;
            key = 128'h000102030405060708090a0b0c0d0e0f;
            data_in = 128'h00112233445566778899aabbccddeeff;

            @(posedge clk);
            #1;
            #1;

            check_outputs(128'h69c4e0d86a7b0430d8cdb78070b4c55a);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [127:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, key, mode, reset, data_out);
    end

endmodule
