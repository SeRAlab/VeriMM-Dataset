`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg DQSW270;
    reg ECLK;
    reg RST;
    reg SCLK;
    reg T0;
    reg T1;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DQSW270(DQSW270),
        .ECLK(ECLK),
        .RST(RST),
        .SCLK(SCLK),
        .T0(T0),
        .T1(T1),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        ECLK = 0;
        forever #5 ECLK = ~ECLK;
    end

        task reset_dut;

        begin
            RST = 1;
            DQSW270 = 0;
            SCLK = 0;
            T0 = 0;
            T1 = 0;
            repeat(2) @(posedge ECLK);
            #2 RST = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Load T1=1, T0=0, check MSB", test_num);
            reset_dut();
            T1 = 1; T0 = 0;
            #10 SCLK = 1; #10 SCLK = 0;
            @(posedge ECLK);
            #2;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Load T1=1, T0=0, check LSB after shift", test_num);
            reset_dut();
            T1 = 1; T0 = 0;
            #10 SCLK = 1; #10 SCLK = 0;
            @(posedge ECLK);
            @(posedge ECLK);
            #2;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Load T1=0, T1=1, check MSB", test_num);
            reset_dut();
            T1 = 0; T0 = 1;
            #10 SCLK = 1; #10 SCLK = 0;
            @(posedge ECLK);
            #2;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Load T1=0, T1=1, check LSB after shift", test_num);
            reset_dut();
            T1 = 0; T0 = 1;
            #10 SCLK = 1; #10 SCLK = 0;
            @(posedge ECLK);
            @(posedge ECLK);
            #2;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Reset trigger with DQSW270 and RST", test_num);
            reset_dut();
            T1 = 1; T0 = 1;
            #10 SCLK = 1; #10 SCLK = 0;

            DQSW270 = 1;
            RST = 1;
            @(posedge ECLK);
            #2;
            #1;

            check_outputs(0);
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
        input expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%b",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b",
                         expected_Q);
                $display("  Got:      Q=%b",
                         Q);
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
        $dumpvars(0,DQSW270, ECLK, RST, SCLK, T0, T1, Q);
    end

endmodule
