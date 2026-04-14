`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg areset;
    reg clk;
    reg [3:0] data;
    reg ena;
    reg load;
    wire [15:0] jc_q;
    wire [3:0] shift_q;
    wire [7:0] xor_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .areset(areset),
        .clk(clk),
        .data(data),
        .ena(ena),
        .load(load),
        .jc_q(jc_q),
        .shift_q(shift_q),
        .xor_output(xor_output)
    );

    // Clock generation (10ns period)
    initial begin
        areset = 0;
        forever #5 areset = ~areset;
    end

        task reset_dut;

    begin
        areset = 1;
        load = 0;
        ena = 0;
        data = 0;
        #15;
        areset = 0;
        #5;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Asynchronous Reset Check");
        reset_dut();

        #1;


        check_outputs(16'h0000, 4'h0, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Load Data Operation");
        reset_dut();
        @(posedge clk);
        data = 4'b1011;
        load = 1;
        @(posedge clk);
        #2;
        load = 0;

        #1;


        check_outputs(16'h0000, 4'hB, xor_output);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Shift Left Operation");
        reset_dut();

        @(posedge clk);
        data = 4'b0101;
        load = 1;
        @(posedge clk);
        #2;
        load = 0;
        ena = 1;
        @(posedge clk);
        #2;
        ena = 0;

        #1;


        check_outputs(jc_q, 4'hA, xor_output);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Multi-cycle Shift Operation");
        reset_dut();
        @(posedge clk);
        data = 4'b1111;
        load = 1;
        @(posedge clk);
        #2;
        load = 0;
        ena = 1;
        repeat(2) @(posedge clk);
        #2;
        ena = 0;

        #1;


        check_outputs(jc_q, 4'hC, xor_output);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Load Priority Check");
        reset_dut();
        @(posedge clk);
        data = 4'b0001;
        load = 1;
        ena = 1;
        @(posedge clk);
        #2;



        #1;




        check_outputs(jc_q, 4'h1, xor_output);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase 006: Enable Inactive Hold Check");
        reset_dut();
        @(posedge clk);
        data = 4'b1001;
        load = 1;
        @(posedge clk);
        #2;
        load = 0;
        ena = 0;
        repeat(3) @(posedge clk);
        #2;

        #1;


        check_outputs(jc_q, 4'h9, xor_output);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase 007: Async Reset During Run");
        reset_dut();
        @(posedge clk);
        data = 4'hF;
        load = 1;
        @(posedge clk);
        #2;
        load = 0;
        ena = 1;
        @(posedge clk);
        #2 areset = 1;
        #2;
        #1;

        check_outputs(16'h0000, 4'h0, 8'h00);
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
        input [15:0] expected_jc_q;
        input [3:0] expected_shift_q;
        input [7:0] expected_xor_output;
        begin
            if (expected_jc_q === (expected_jc_q ^ jc_q ^ expected_jc_q) &&
                expected_shift_q === (expected_shift_q ^ shift_q ^ expected_shift_q) &&
                expected_xor_output === (expected_xor_output ^ xor_output ^ expected_xor_output)) begin
                $display("PASS");
                $display("  Outputs: jc_q=%h, shift_q=%h, xor_output=%h",
                         jc_q, shift_q, xor_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: jc_q=%h, shift_q=%h, xor_output=%h",
                         expected_jc_q, expected_shift_q, expected_xor_output);
                $display("  Got:      jc_q=%h, shift_q=%h, xor_output=%h",
                         jc_q, shift_q, xor_output);
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
        $dumpvars(0,areset, clk, data, ena, load, jc_q, shift_q, xor_output);
    end

endmodule
