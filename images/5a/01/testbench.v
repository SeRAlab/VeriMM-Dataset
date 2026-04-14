`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg CLR;
    reg D;
    reg PRE;
    wire QN;
    wire QNF;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .CLR(CLR),
        .D(D),
        .PRE(PRE),
        .QN(QN),
        .QNF(QNF)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            PRE = 0;
            CLR = 1;
            D = 0;
            #12;
            CLR = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Asynchronous CLR assertion", test_num);
            reset_dut();

            PRE = 0;
            CLR = 1;
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Asynchronous PRE assertion", test_num);
            reset_dut();
            CLR = 0;
            PRE = 1;
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Synchronous Load D=1", test_num);
            reset_dut();
            PRE = 0;
            CLR = 0;
            D = 1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Synchronous Load D=0", test_num);
            reset_dut();

            PRE = 1; #5; PRE = 0;
            D = 0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Asynchronous CLR priority over Synchronous D", test_num);
            reset_dut();
            D = 1;
            CLR = 1;
            @(posedge CLK);
            #2;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Asynchronous PRE priority over Synchronous D", test_num);
            reset_dut();
            D = 0;
            PRE = 1;
            @(posedge CLK);
            #2;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Toggling Async PRE/CLR between clock edges", test_num);
            reset_dut();
            CLR = 0; PRE = 1; #2;
            PRE = 0; CLR = 1; #2;
            #1;

            check_outputs(1'b0, 1'b1);
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
        input expected_QN;
        input expected_QNF;
        begin
            if (expected_QN === (expected_QN ^ QN ^ expected_QN) &&
                expected_QNF === (expected_QNF ^ QNF ^ expected_QNF)) begin
                $display("PASS");
                $display("  Outputs: QN=%b, QNF=%b",
                         QN, QNF);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: QN=%b, QNF=%b",
                         expected_QN, expected_QNF);
                $display("  Got:      QN=%b, QNF=%b",
                         QN, QNF);
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
        $dumpvars(0,CLK, CLR, D, PRE, QN, QNF);
    end

endmodule
