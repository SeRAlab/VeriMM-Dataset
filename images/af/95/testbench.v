`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg BITSTRB;
    reg BITVAL;
    reg CLEAR;
    reg ENABLE;
    wire [15:0] CRC;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BITSTRB(BITSTRB),
        .BITVAL(BITVAL),
        .CLEAR(CLEAR),
        .ENABLE(ENABLE),
        .CRC(CRC)
    );

    // Clock generation (10ns period)
    initial begin
        BITSTRB = 0;
        forever #5 BITSTRB = ~BITSTRB;
    end

        task reset_dut;

    begin
        CLEAR = 1;
        ENABLE = 0;
        BITVAL = 0;
        @(posedge BITSTRB);
        #1;
        CLEAR = 0;
        @(posedge BITSTRB);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Power-on Reset", test_num);
        reset_dut();
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Enable signal check", test_num);
        reset_dut();
        ENABLE = 0;
        BITVAL = 1;
        repeat (5) @(posedge BITSTRB);
        #1;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Single bit '1' calculation", test_num);
        reset_dut();
        ENABLE = 1;
        BITVAL = 1;
        @(posedge BITSTRB);
        #1;
        ENABLE = 0;
        #1;

        check_outputs(16'h8005);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Two-bit sequence 10", test_num);
        reset_dut();
        ENABLE = 1;
        BITVAL = 1; @(posedge BITSTRB); #1;
        BITVAL = 0; @(posedge BITSTRB); #1;
        ENABLE = 0;
        #1;

        check_outputs(16'h800B);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Sequence 1011 calculation", test_num);
        reset_dut();
        ENABLE = 1;
        BITVAL = 1; @(posedge BITSTRB); #1;
        BITVAL = 0; @(posedge BITSTRB); #1;
        BITVAL = 1; @(posedge BITSTRB); #1;
        BITVAL = 1; @(posedge BITSTRB); #1;
        ENABLE = 0;
        #1;

        check_outputs(16'h800D);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Mid-stream CLEAR check", test_num);
        reset_dut();
        ENABLE = 1;
        BITVAL = 1; @(posedge BITSTRB); #1;
        BITVAL = 1; @(posedge BITSTRB); #1;
        CLEAR = 1;  @(posedge BITSTRB); #1;
        CLEAR = 0;
        ENABLE = 0;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: All zeros input", test_num);
        reset_dut();
        ENABLE = 1;
        BITVAL = 0;
        repeat (16) @(posedge BITSTRB);
        #1;
        ENABLE = 0;
        #1;

        check_outputs(16'h0000);
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
        input [15:0] expected_CRC;
        begin
            if (expected_CRC === (expected_CRC ^ CRC ^ expected_CRC)) begin
                $display("PASS");
                $display("  Outputs: CRC=%h",
                         CRC);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CRC=%h",
                         expected_CRC);
                $display("  Got:      CRC=%h",
                         CRC);
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
        $dumpvars(0,BITSTRB, BITVAL, CLEAR, ENABLE, CRC);
    end

endmodule
