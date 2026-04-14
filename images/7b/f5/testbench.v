`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CK;
    reg D;
    reg RN;
    reg SE;
    reg SI;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CK(CK),
        .D(D),
        .RN(RN),
        .SE(SE),
        .SI(SI),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CK = 0;
        forever #5 CK = ~CK;
    end

        task reset_dut;

        begin
            RN = 0;
            D = 0;
            SE = 0;
            SI = 0;
            @(posedge CK);
            #1;
            RN = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verify Synchronous Reset", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Load D=1 (SE=0)", test_num);
            reset_dut();
            D = 1;
            SE = 0;
            @(posedge CK);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Load SI=1 (SE=1)", test_num);
            reset_dut();
            D = 0;
            SI = 1;
            SE = 1;
            @(posedge CK);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Ignore SI when SE=0", test_num);
            reset_dut();
            D = 0;
            SI = 1;
            SE = 0;
            @(posedge CK);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Ignore D when SE=1", test_num);
            reset_dut();
            D = 1;
            SI = 0;
            SE = 1;
            @(posedge CK);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset priority over SE and SI", test_num);
            reset_dut();

            D = 1; SE = 0;
            @(posedge CK); #1;

            RN = 0; SI = 1; SE = 1;
            @(posedge CK);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multi-cycle toggle sequence", test_num);
            reset_dut();

            D = 1; SE = 0;
            @(posedge CK); #1;

            D = 1; SI = 0; SE = 1;
            @(posedge CK); #1;

            D = 1; SE = 0;
            @(posedge CK); #1;
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
        $dumpvars(0,CK, D, RN, SE, SI, Q);
    end

endmodule
