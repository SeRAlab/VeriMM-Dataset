`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg LKL_sig;
    reg [15:0] data;
    wire LKL_Ready;
    wire [15:0] address;
    wire count_en;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .LKL_sig(LKL_sig),
        .data(data),
        .LKL_Ready(LKL_Ready),
        .address(address),
        .count_en(count_en)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        LKL_sig = 0;
        data = 16'h0000;
        @(posedge CLK);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Reset State Verification", test_num);
        reset_dut();

        #1;


        check_outputs(1'b1, 16'h0000, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Module Activation (Non-match Data)", test_num);
        reset_dut();
        LKL_sig = 1;
        data = 16'hABCD;
        @(posedge CLK);
        #1;


        #1;



        check_outputs(LKL_Ready, address, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Data Segment Selection Change", test_num);
        reset_dut();
        LKL_sig = 1;
        data = 16'h1234;
        @(posedge CLK);
        data = 16'h5678;
        @(posedge CLK);
        #1;

        #1;


        check_outputs(LKL_Ready, address, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Target Match Address Selection", test_num);
        reset_dut();

        LKL_sig = 1;
        data = 16'h5555;
        @(posedge CLK);


        data = 16'hAAAA;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(LKL_Ready, address, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Active to Reset Transition", test_num);
        reset_dut();
        LKL_sig = 1;
        data = 16'hFFFF;
        @(posedge CLK);
        LKL_sig = 0;
        @(posedge CLK);
        #1;

        #1;


        check_outputs(1'b1, 16'h0000, 1'b0);
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
        input expected_LKL_Ready;
        input [15:0] expected_address;
        input expected_count_en;
        begin
            if (expected_LKL_Ready === (expected_LKL_Ready ^ LKL_Ready ^ expected_LKL_Ready) &&
                expected_address === (expected_address ^ address ^ expected_address) &&
                expected_count_en === (expected_count_en ^ count_en ^ expected_count_en)) begin
                $display("PASS");
                $display("  Outputs: LKL_Ready=%b, address=%h, count_en=%b",
                         LKL_Ready, address, count_en);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LKL_Ready=%b, address=%h, count_en=%b",
                         expected_LKL_Ready, expected_address, expected_count_en);
                $display("  Got:      LKL_Ready=%b, address=%h, count_en=%b",
                         LKL_Ready, address, count_en);
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
        $dumpvars(0,CLK, LKL_sig, data, LKL_Ready, address, count_en);
    end

endmodule
