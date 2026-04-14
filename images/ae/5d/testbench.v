`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CDN;
    reg CK;
    reg D;
    reg SE;
    reg SI;
    wire Q;
    wire scQ;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CDN(CDN),
        .CK(CK),
        .D(D),
        .SE(SE),
        .SI(SI),
        .Q(Q),
        .scQ(scQ)
    );

    // Clock generation (10ns period)
    initial begin
        CDN = 0;
        forever #5 CDN = ~CDN;
    end

        task reset_dut;

    begin
        CDN = 0;
        D = 0;
        SE = 0;
        SI = 0;
        #12;
        CDN = 1;
        #2;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        @(negedge CK);
        SE = 0;
        D = 1;
        SI = 0;
        @(posedge CK);
        #2;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();

        @(negedge CK);
        SE = 0; D = 1;
        @(posedge CK);
        #2;

        @(negedge CK);
        D = 0;
        @(posedge CK);
        #2;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        @(negedge CK);
        SE = 1;
        D = 0;
        SI = 1;
        @(posedge CK);
        #2;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        @(negedge CK);
        SE = 1;
        SI = 0;
        @(posedge CK);
        #2;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        @(negedge CK);
        SE = 1;
        D = 1;
        SI = 0;
        @(posedge CK);
        #2;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        reset_dut();

        @(negedge CK);
        SE = 0; D = 1;
        @(posedge CK);
        #2;

        #2;
        CDN = 0;
        #1;
        #1;

        check_outputs(1'b0, 1'b0);
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
        input expected_scQ;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_scQ === (expected_scQ ^ scQ ^ expected_scQ)) begin
                $display("PASS");
                $display("  Outputs: Q=%b, scQ=%b",
                         Q, scQ);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b, scQ=%b",
                         expected_Q, expected_scQ);
                $display("  Got:      Q=%b, scQ=%b",
                         Q, scQ);
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
        $dumpvars(0,CDN, CK, D, SE, SI, Q, scQ);
    end

endmodule
