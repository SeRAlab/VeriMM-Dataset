`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg RESETn;
    reg requestIn;
    reg requestWR;
    reg signalIn;
    reg signalMask;
    wire requestOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .RESETn(RESETn),
        .requestIn(requestIn),
        .requestWR(requestWR),
        .signalIn(signalIn),
        .signalMask(signalMask),
        .requestOut(requestOut)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RESETn = 0;
            requestIn = 0;
            requestWR = 0;
            signalIn = 0;
            signalMask = 0;
            repeat(2) @(posedge CLK);
            #1 RESETn = 1;
            repeat(1) @(posedge CLK);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %03d: Initial Reset State", test_num);
            @(negedge CLK);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %03d: Signal Triggered (Masked High)", test_num);
            @(negedge CLK);
            signalIn = 1;
            signalMask = 1;
            requestWR = 0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase %03d: Signal Inhibited (Masked Low)", test_num);
            @(negedge CLK);
            signalIn = 1;
            signalMask = 0;
            requestWR = 0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase %03d: Manual Write Set", test_num);
            @(negedge CLK);
            requestWR = 1;
            requestIn = 1;
            signalIn = 0;
            signalMask = 0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase %03d: Manual Write Priority over Signal", test_num);
            @(negedge CLK);

            signalIn = 1;
            signalMask = 1;

            requestWR = 1;
            requestIn = 0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Testcase %03d: Continuous Signal Check", test_num);
            @(negedge CLK);
            signalIn = 1;
            signalMask = 1;
            @(posedge CLK);
            #2;
            @(negedge CLK);
            signalIn = 0;
            @(posedge CLK);
            #2;


            #1;



            check_outputs(1'b0);
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
        input expected_requestOut;
        begin
            if (expected_requestOut === (expected_requestOut ^ requestOut ^ expected_requestOut)) begin
                $display("PASS");
                $display("  Outputs: requestOut=%b",
                         requestOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: requestOut=%b",
                         expected_requestOut);
                $display("  Got:      requestOut=%b",
                         requestOut);
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
        $dumpvars(0,CLK, RESETn, requestIn, requestWR, signalIn, signalMask, requestOut);
    end

endmodule
