`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg D;
    reg EN;
    reg TE;
    wire ENCLK;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .D(D),
        .EN(EN),
        .TE(TE),
        .ENCLK(ENCLK),
        .Q(Q)
    );

        task reset_dut;

        begin
            CLK = 0;
            D = 0;
            EN = 0;
            TE = 1;
            #10;
            CLK = 1;
            #10;
            CLK = 0;
            TE = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Test mode (TE=1), rising edge", test_num);
            TE = 1; EN = 0; D = 1;
            #10 CLK = 1;
            #10;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Test mode (TE=1), falling edge (Dual-edge)", test_num);
            TE = 1; EN = 0; D = 1;
            #10 CLK = 1;
            #10 D = 0;
            #10 CLK = 0;
            #10;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Normal mode (EN=1), rising edge", test_num);
            TE = 0; EN = 1; D = 1;
            #10 CLK = 1;
            #10;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Normal mode (EN=1), falling edge (Dual-edge)", test_num);
            TE = 0; EN = 1; D = 1;
            #10 CLK = 1;
            #10 D = 0;
            #10 CLK = 0;
            #10;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Gated mode (EN=0), no update", test_num);
            TE = 0; EN = 0; D = 1;
            #10 CLK = 1;
            #10 CLK = 0;
            #10;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: TE overriding EN", test_num);
            TE = 1; EN = 0; D = 1;
            #10 CLK = 1;
            #10;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Testcase %0d: Gating transition (EN 1->0 mid-high CLK)", test_num);
            TE = 0; EN = 1; D = 1;
            #10 CLK = 1;
            #10 EN = 0;
            #10 D = 0;
            #10 CLK = 0;
            #10;
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
        input expected_ENCLK;
        input expected_Q;
        begin
            if (expected_ENCLK === (expected_ENCLK ^ ENCLK ^ expected_ENCLK) &&
                expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: ENCLK=%b, Q=%b",
                         ENCLK, Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ENCLK=%b, Q=%b",
                         expected_ENCLK, expected_Q);
                $display("  Got:      ENCLK=%b, Q=%b",
                         ENCLK, Q);
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
        $dumpvars(0,CLK, D, EN, TE, ENCLK, Q);
    end

endmodule
