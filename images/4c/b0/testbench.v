`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [63:0] dataa;
    reg [31:0] datab;
    reg resetn;
    reg stall_in;
    reg valid_in;
    wire [63:0] result;
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
        .datab(datab),
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
            valid_in = 0;
            stall_in = 0;
            dataa = 0;
            datab = 0;
            @(posedge clock);
            #1;
            resetn = 1;
            @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Basic shift (1.0 << 1)", test_num);
            dataa = 64'h3FF0000000000000;
            datab = 32'd1;
            valid_in = 1;
            @(posedge clock);
            valid_in = 0;


            while (!valid_out) @(posedge clock);
            #1;
            #1;

            check_outputs(64'h4000000000000000, 0, 1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Zero input", test_num);
            dataa = 64'h0000000000000000;
            datab = 32'd10;
            valid_in = 1;
            @(posedge clock);
            valid_in = 0;

            while (!valid_out) @(posedge clock);
            #1;
            #1;

            check_outputs(64'h0000000000000000, 0, 1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Negative shift (-2.0 << 2)", test_num);
            dataa = 64'hC000000000000000;
            datab = 32'd2;
            valid_in = 1;
            @(posedge clock);
            valid_in = 0;

            while (!valid_out) @(posedge clock);
            #1;
            #1;

            check_outputs(64'hC020000000000000, 0, 1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Overflow to Infinity", test_num);
            dataa = 64'h3FF0000000000000;
            datab = 32'd2000;
            valid_in = 1;
            @(posedge clock);
            valid_in = 0;

            while (!valid_out) @(posedge clock);
            #1;
            #1;

            check_outputs(64'h7FF0000000000000, 0, 1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Shift by 0", test_num);
            dataa = 64'h3FF8000000000000;
            datab = 32'd0;
            valid_in = 1;
            @(posedge clock);
            valid_in = 0;

            while (!valid_out) @(posedge clock);
            #1;
            #1;

            check_outputs(64'h3FF8000000000000, 0, 1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Stall handling", test_num);
            dataa = 64'h3FF0000000000000;
            datab = 32'd5;
            valid_in = 1;
            stall_in = 1;
            @(posedge clock);
            valid_in = 0;


            repeat(3) @(posedge clock);

            stall_in = 0;
            while (!valid_out) @(posedge clock);
            #1;
            #1;

            check_outputs(64'h4040000000000000, 0, 1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Infinity stays Infinity", test_num);
            dataa = 64'h7FF0000000000000;
            datab = 32'd5;
            valid_in = 1;
            @(posedge clock);
            valid_in = 0;

            while (!valid_out) @(posedge clock);
            #1;
            #1;

            check_outputs(64'h7FF0000000000000, 0, 1);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Max normal overflow", test_num);
            dataa = 64'h7FEFFFFFFFFFFFFF;
            datab = 32'd1;
            valid_in = 1;
            @(posedge clock);
            valid_in = 0;

            while (!valid_out) @(posedge clock);
            #1;
            #1;

            check_outputs(64'h7FF0000000000000, 0, 1);
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
        testcase007();
        testcase008();
        
        
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
        input [63:0] expected_result;
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
        $dumpvars(0,clock, dataa, datab, resetn, stall_in, valid_in, result, stall_out, valid_out);
    end

endmodule
