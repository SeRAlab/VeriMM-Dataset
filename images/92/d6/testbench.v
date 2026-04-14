`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg debug_req_ready;
    reg [31:0] debug_resp_bits_data;
    reg [1:0] debug_resp_bits_resp;
    reg debug_resp_valid;
    reg reset;
    wire [6:0] debug_req_bits_addr;
    wire [31:0] debug_req_bits_data;
    wire [1:0] debug_req_bits_op;
    wire debug_req_valid;
    wire debug_resp_ready;
    wire [31:0] exit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .debug_req_ready(debug_req_ready),
        .debug_resp_bits_data(debug_resp_bits_data),
        .debug_resp_bits_resp(debug_resp_bits_resp),
        .debug_resp_valid(debug_resp_valid),
        .reset(reset),
        .debug_req_bits_addr(debug_req_bits_addr),
        .debug_req_bits_data(debug_req_bits_data),
        .debug_req_bits_op(debug_req_bits_op),
        .debug_req_valid(debug_req_valid),
        .debug_resp_ready(debug_resp_ready),
        .exit(exit)
    );
    task testcase001;

        begin
            $display("\nTest Case 001: Reset with zero inputs");
            reset = 1;
            debug_req_ready = 0;
            debug_resp_valid = 0;
            debug_resp_bits_resp = 0;
            debug_resp_bits_data = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;

            check_outputs(7'h0, 32'h0, 2'h0, 1'b0, 1'b0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            $display("\nTest Case 002: Reset with high debug_req_ready");
            reset = 1;
            debug_req_ready = 1;
            debug_resp_valid = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;

            check_outputs(7'h0, 32'h0, 2'h0, 1'b0, 1'b0, 32'h0);
        end
        endtask

    task testcase003;

        begin
            $display("\nTest Case 003: Reset with incoming debug response data");
            reset = 1;
            debug_req_ready = 0;
            debug_resp_valid = 1;
            debug_resp_bits_resp = 2'b11;
            debug_resp_bits_data = 32'hDEADBEEF;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;

            check_outputs(7'h0, 32'h0, 2'h0, 1'b0, 1'b0, 32'h0);
        end
        endtask

    task testcase004;

        begin
            $display("\nTest Case 004: Persistence of inactive state over multiple cycles");
            reset = 1;
            @(posedge clk);
            #1 reset = 0;
            debug_req_ready = 1;
            debug_resp_valid = 1;
            debug_resp_bits_resp = 2'b01;
            debug_resp_bits_data = 32'hCAFEBABE;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(7'h0, 32'h0, 2'h0, 1'b0, 1'b0, 32'h0);
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
        input [6:0] expected_debug_req_bits_addr;
        input [31:0] expected_debug_req_bits_data;
        input [1:0] expected_debug_req_bits_op;
        input expected_debug_req_valid;
        input expected_debug_resp_ready;
        input [31:0] expected_exit;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_debug_req_bits_addr === (expected_debug_req_bits_addr ^ debug_req_bits_addr ^ expected_debug_req_bits_addr) &&
                expected_debug_req_bits_data === (expected_debug_req_bits_data ^ debug_req_bits_data ^ expected_debug_req_bits_data) &&
                expected_debug_req_bits_op === (expected_debug_req_bits_op ^ debug_req_bits_op ^ expected_debug_req_bits_op) &&
                expected_debug_req_valid === (expected_debug_req_valid ^ debug_req_valid ^ expected_debug_req_valid) &&
                expected_debug_resp_ready === (expected_debug_resp_ready ^ debug_resp_ready ^ expected_debug_resp_ready) &&
                expected_exit === (expected_exit ^ exit ^ expected_exit)) begin
                $display("PASS");
                $display("  Outputs: debug_req_bits_addr=%h, debug_req_bits_data=%h, debug_req_bits_op=%h, debug_req_valid=%b, debug_resp_ready=%b, exit=%h",
                         debug_req_bits_addr, debug_req_bits_data, debug_req_bits_op, debug_req_valid, debug_resp_ready, exit);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: debug_req_bits_addr=%h, debug_req_bits_data=%h, debug_req_bits_op=%h, debug_req_valid=%b, debug_resp_ready=%b, exit=%h",
                         expected_debug_req_bits_addr, expected_debug_req_bits_data, expected_debug_req_bits_op, expected_debug_req_valid, expected_debug_resp_ready, expected_exit);
                $display("  Got:      debug_req_bits_addr=%h, debug_req_bits_data=%h, debug_req_bits_op=%h, debug_req_valid=%b, debug_resp_ready=%b, exit=%h",
                         debug_req_bits_addr, debug_req_bits_data, debug_req_bits_op, debug_req_valid, debug_resp_ready, exit);
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

endmodule
