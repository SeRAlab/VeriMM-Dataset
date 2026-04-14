`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CK;
    reg E;
    reg SE;
    wire ECK;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CK(CK),
        .E(E),
        .SE(SE),
        .ECK(ECK)
    );

    // Clock generation (10ns period)
    initial begin
        CK = 0;
        forever #5 CK = ~CK;
    end

        task reset_dut;

        begin
            SE = 1;
            E = 0;
            @(posedge CK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();

            SE = 1;
            E = 0;
            @(posedge CK);
            #1;
            $display("Testcase %0d: SE=1, E=0 -> Expected ECK=1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            SE = 0;
            E = 1;
            @(posedge CK);
            #1;
            $display("Testcase %0d: SE=0, E=1 -> Expected ECK=0", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            SE = 1;
            E = 1;
            @(posedge CK);
            #1;
            $display("Testcase %0d: SE=1, E=1 -> Expected ECK=1 (SE priority)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();

            SE = 0;
            E = 1;
            @(posedge CK);
            #1;

            SE = 0;
            E = 0;
            @(posedge CK);
            #1;
            $display("Testcase %0d: Hold state 0 (SE=0, E=0) -> Expected ECK=0", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();

            SE = 1;
            E = 0;
            @(posedge CK);
            #1;

            SE = 0;
            E = 0;
            @(posedge CK);
            #1;
            $display("Testcase %0d: Hold state 1 (SE=0, E=0) -> Expected ECK=1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();

            SE = 0;
            E = 1;
            @(posedge CK);
            #1;

            SE = 1;
            E = 0;
            @(posedge CK);
            #1;
            $display("Testcase %0d: Transition 0 to 1 via SE=1 -> Expected ECK=1", test_num);
            #1;

            check_outputs(1'b1);
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
        input expected_ECK;
        begin
            if (expected_ECK === (expected_ECK ^ ECK ^ expected_ECK)) begin
                $display("PASS");
                $display("  Outputs: ECK=%b",
                         ECK);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ECK=%b",
                         expected_ECK);
                $display("  Got:      ECK=%b",
                         ECK);
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
        $dumpvars(0,CK, E, SE, ECK);
    end

endmodule
