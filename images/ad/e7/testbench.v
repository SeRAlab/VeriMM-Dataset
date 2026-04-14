`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg D;
    reg nRST;
    wire nQ;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .D(D),
        .nRST(nRST),
        .nQ(nQ)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            nRST = 1'b0;
            D = 1'b0;
            #15;
            nRST = 1'b1;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Verify Reset (nQ should be HIGH)", test_num);
            reset_dut();

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Clocking D=0 (Expect nQ=1)", test_num);
            reset_dut();
            D = 1'b0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Clocking D=1 (Expect nQ=0)", test_num);
            reset_dut();
            D = 1'b1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Asynchronous Reset Override", test_num);
            reset_dut();
            D = 1'b1;
            @(posedge CLK);
            #2;
            nRST = 1'b0;
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Stability between clock edges", test_num);
            reset_dut();
            D = 1'b0;
            @(posedge CLK);
            #2;
            D = 1'b1;
            #3;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Successive transitions", test_num);
            reset_dut();

            D = 1'b1;
            @(posedge CLK);
            #2;

            D = 1'b0;
            @(posedge CLK);
            #2;

            D = 1'b1;
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
        input expected_nQ;
        begin
            if (expected_nQ === (expected_nQ ^ nQ ^ expected_nQ)) begin
                $display("PASS");
                $display("  Outputs: nQ=%b",
                         nQ);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: nQ=%b",
                         expected_nQ);
                $display("  Got:      nQ=%b",
                         nQ);
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
        $dumpvars(0,CLK, D, nRST, nQ);
    end

endmodule
