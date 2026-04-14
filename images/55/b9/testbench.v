`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Tx0;
    reg Tx1;
    reg TxClk;
    reg TxReset;
    wire D;
    wire S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Tx0(Tx0),
        .Tx1(Tx1),
        .TxClk(TxClk),
        .TxReset(TxReset),
        .D(D),
        .S(S)
    );

    // Clock generation (10ns period)
    initial begin
        TxClk = 0;
        forever #5 TxClk = ~TxClk;
    end

        task reset_dut;

        begin
            TxReset = 1;
            Tx0 = 0;
            Tx1 = 0;
            @(posedge TxClk);
            #2;
            TxReset = 0;
            test_num = test_num + 1;
        end
        endtask
    task testcase001;

        begin
            TxReset = 1;
            Tx0 = 1; Tx1 = 1;
            #15;
            TxReset = 0;
            test_num = 1;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(negedge TxClk);
            Tx1 = 1; Tx0 = 0;
            @(posedge TxClk);
            #2;


            #1;



            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            @(negedge TxClk);
            Tx1 = 0; Tx0 = 1;
            @(posedge TxClk);
            #2;


            #1;



            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            @(negedge TxClk);
            Tx1 = 1; Tx0 = 1;
            @(posedge TxClk);
            #2;



            @(negedge TxClk);
            Tx1 = 0; Tx0 = 1;
            @(posedge TxClk);
            #2;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            @(negedge TxClk);
            Tx1 = 1; Tx0 = 0;
            @(posedge TxClk); #2;

            @(negedge TxClk);
            Tx1 = 1; Tx0 = 1;
            @(posedge TxClk); #2;

            @(negedge TxClk);
            Tx1 = 1; Tx0 = 0;
            @(posedge TxClk); #2;
            #1;

            check_outputs(1'b1, 1'b0);
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
        input expected_D;
        input expected_S;
        begin
            if (expected_D === (expected_D ^ D ^ expected_D) &&
                expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: D=%b, S=%b",
                         D, S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D=%b, S=%b",
                         expected_D, expected_S);
                $display("  Got:      D=%b, S=%b",
                         D, S);
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
        $dumpvars(0,Tx0, Tx1, TxClk, TxReset, D, S);
    end

endmodule
