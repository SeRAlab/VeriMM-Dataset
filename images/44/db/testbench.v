`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [31:0] dataa;
    reg enable;
    reg resetn;
    reg stall_in;
    reg valid_in;
    wire [31:0] result;
    wire stall_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .dataa(dataa),
        .enable(enable),
        .resetn(resetn),
        .stall_in(stall_in),
        .valid_in(valid_in),
        .result(result),
        .stall_out(stall_out),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            resetn = 0;
            enable = 0;
            valid_in = 0;
            stall_in = 0;
            dataa = 0;
            @(posedge clock);
            #1;
            resetn = 1;
            @(posedge clock);
            #1;
        end
        endtask
    task wait_for_valid;

        integer timeout;
        begin
            timeout = 0;
            while (!valid_out && timeout < 20) begin
                @(posedge clock);
                #1;
                timeout = timeout + 1;
            end
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Positive Normal (1.0)", test_num);
            reset_dut();
            dataa = 32'h3F800000;
            valid_in = 1;
            enable = 1;
            stall_in = 0;
            wait_for_valid();
            #1;

            check_outputs(32'h0000007F, 0, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative Normal (-2.0)", test_num);
            reset_dut();
            dataa = 32'hC0000000;
            valid_in = 1;
            enable = 1;
            stall_in = 0;
            wait_for_valid();
            #1;

            check_outputs(32'h00000080, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero", test_num);
            reset_dut();
            dataa = 32'h00000000;
            valid_in = 1;
            enable = 1;
            stall_in = 0;
            wait_for_valid();
            #1;

            check_outputs(32'h00000000, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Infinity", test_num);
            reset_dut();
            dataa = 32'h7F800000;
            valid_in = 1;
            enable = 1;
            stall_in = 0;
            wait_for_valid();
            #1;

            check_outputs(32'h000000FF, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Small Value (0.5)", test_num);
            reset_dut();
            dataa = 32'h3F000000;
            valid_in = 1;
            enable = 1;
            stall_in = 0;
            wait_for_valid();
            #1;

            check_outputs(32'h0000007E, 0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Normal Float", test_num);
            reset_dut();
            dataa = 32'h7F7FFFFF;
            valid_in = 1;
            enable = 1;
            stall_in = 0;
            wait_for_valid();
            #1;

            check_outputs(32'h000000FE, 0, 1);
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
        input [31:0] expected_result;
        input expected_stall_out;
        input expected_valid_out;
        begin
            if (expected_result === (expected_result ^ result ^ expected_result) &&
                expected_stall_out === (expected_stall_out ^ stall_out ^ expected_stall_out) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: result=%h, stall_out=%b, valid_out=%b",
                         result, stall_out, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h, stall_out=%b, valid_out=%b",
                         expected_result, expected_stall_out, expected_valid_out);
                $display("  Got:      result=%h, stall_out=%b, valid_out=%b",
                         result, stall_out, valid_out);
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
        $dumpvars(0,clock, dataa, enable, resetn, stall_in, valid_in, result, stall_out, valid_out);
    end

endmodule
