`timescale 1ns/1ps

module AES_AddRoundKey_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] round_key;
    reg rst;
    reg [127:0] state_in;
    wire [127:0] state_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    AES_AddRoundKey dut (
        .clk(clk),
        .round_key(round_key),
        .rst(rst),
        .state_in(state_in),
        .state_out(state_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        state_in = 0;
        round_key = 0;
        @(posedge clk);
        #1;
        rst = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All Zeros State and Key", test_num);
        reset_dut();
        state_in = 128'h0;
        round_key = 128'h0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(128'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All Ones State and Key", test_num);
        reset_dut();
        state_in = {128{1'b1}};
        round_key = {128{1'b1}};
        @(posedge clk);
        #1;
        #1;

        check_outputs(128'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Zero State with Arbitrary Key", test_num);
        reset_dut();
        state_in = 128'h0;
        round_key = 128'h2b7e151628aed2a6abf7158809cf4f3c;
        @(posedge clk);
        #1;
        #1;

        check_outputs(128'h2b7e151628aed2a6abf7158809cf4f3c);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: NIST Test Vector RoundKey Operation", test_num);
        reset_dut();

        state_in  = 128'h3243f6a8885a308d313198a2e0370734;
        round_key = 128'h2b7e151628aed2a6abf7158809cf4f3c;

        @(posedge clk);
        #1;
        #1;

        check_outputs(128'h193de3bea0f4e22b9ac68d2ae9f84808);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Alternating Bits (0xAA ^ 0x55)", test_num);
        reset_dut();
        state_in  = 128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
        round_key = 128'h55555555555555555555555555555555;
        @(posedge clk);
        #1;
        #1;

        check_outputs(128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset behavior (Output should be 0 during reset)", test_num);
        reset_dut();
        state_in  = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
        round_key = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
        rst = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(128'h0);
        rst = 0;
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("AES_AddRoundKey Testbench");
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
        input [127:0] expected_state_out;
        begin
            if (expected_state_out === (expected_state_out ^ state_out ^ expected_state_out)) begin
                $display("PASS");
                $display("  Outputs: state_out=%h",
                         state_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: state_out=%h",
                         expected_state_out);
                $display("  Got:      state_out=%h",
                         state_out);
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
        $dumpvars(0,clk, round_key, rst, state_in, state_out);
    end

endmodule
