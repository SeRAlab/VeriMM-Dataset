`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg CLR;
    reg DEQ;
    reg ENQ;
    reg RST;
    wire EMPTY_N;
    wire FULL_N;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .CLR(CLR),
        .DEQ(DEQ),
        .ENQ(ENQ),
        .RST(RST),
        .EMPTY_N(EMPTY_N),
        .FULL_N(FULL_N)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        RST = 1;
        CLR = 0;
        ENQ = 0;
        DEQ = 0;
        @(posedge CLK);
        #1 RST = 0;
        @(posedge CLK);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %03d: Initial Reset State", test_num);
        reset_dut();
        #1;

        check_outputs(0, 1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %03d: Single Enqueue Operation", test_num);
        reset_dut();
        @(posedge CLK);
        ENQ = 1;
        @(posedge CLK);
        ENQ = 0;
        #1;
        #1;

        check_outputs(1, 1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %03d: Fill FIFO to Capacity", test_num);
        reset_dut();
        @(posedge CLK);
        ENQ = 1;
        @(posedge CLK);
        @(posedge CLK);
        ENQ = 0;
        #1;
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %03d: Enqueue followed by Dequeue", test_num);
        reset_dut();
        @(posedge CLK);
        ENQ = 1;
        @(posedge CLK);
        ENQ = 0;
        DEQ = 1;
        @(posedge CLK);
        DEQ = 0;
        #1;
        #1;

        check_outputs(0, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %03d: CLR signal functionality", test_num);
        reset_dut();
        @(posedge CLK);
        ENQ = 1;
        @(posedge CLK);
        ENQ = 0;
        CLR = 1;
        @(posedge CLK);
        CLR = 0;
        #1;
        #1;

        check_outputs(0, 1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %03d: Concurrent ENQ and DEQ", test_num);
        reset_dut();
        @(posedge CLK);
        ENQ = 1;
        @(posedge CLK);
        ENQ = 1;
        DEQ = 1;
        @(posedge CLK);
        ENQ = 0;
        DEQ = 0;
        #1;
        #1;

        check_outputs(1, 1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %03d: Dequeue from Empty Queue", test_num);
        reset_dut();
        @(posedge CLK);
        DEQ = 1;
        @(posedge CLK);
        DEQ = 0;
        #1;
        #1;

        check_outputs(0, 1);
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
        input expected_EMPTY_N;
        input expected_FULL_N;
        begin
            if (expected_EMPTY_N === (expected_EMPTY_N ^ EMPTY_N ^ expected_EMPTY_N) &&
                expected_FULL_N === (expected_FULL_N ^ FULL_N ^ expected_FULL_N)) begin
                $display("PASS");
                $display("  Outputs: EMPTY_N=%b, FULL_N=%b",
                         EMPTY_N, FULL_N);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: EMPTY_N=%b, FULL_N=%b",
                         expected_EMPTY_N, expected_FULL_N);
                $display("  Got:      EMPTY_N=%b, FULL_N=%b",
                         EMPTY_N, FULL_N);
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
        $dumpvars(0,CLK, CLR, DEQ, ENQ, RST, EMPTY_N, FULL_N);
    end

endmodule
