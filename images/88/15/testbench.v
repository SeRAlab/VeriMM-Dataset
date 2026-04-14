`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg EN;
    reg RESET;
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
        .EN(EN),
        .RESET(RESET),
        .TE(TE),
        .ENCLK(ENCLK),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        RESET = 0;
        forever #5 RESET = ~RESET;
    end

        task reset_dut;

        begin
            RESET = 1;
            EN = 0;
            TE = 0;
            #12;
            RESET = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Asynchronous Reset", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Load Logic High (EN=1, TE=1)", test_num);
            reset_dut();
            @(negedge CLK);
            EN = 1;
            TE = 1;
            @(posedge CLK);
            #2;

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Gated Clock Check (EN=0)", test_num);
            reset_dut();
            @(negedge CLK);
            EN = 0;
            TE = 1;
            @(posedge CLK);
            #2;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Data Hold when EN goes Low", test_num);
            reset_dut();

            @(negedge CLK);
            EN = 1; TE = 1;
            @(posedge CLK); #2;

            @(negedge CLK);
            EN = 0; TE = 0;
            @(posedge CLK); #2;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Load Logic Low (EN=1, TE=0)", test_num);
            reset_dut();

            @(negedge CLK);
            EN = 1; TE = 1;
            @(posedge CLK); #2;

            @(negedge CLK);
            TE = 0;
            @(posedge CLK); #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Mid-cycle Async Reset", test_num);
            reset_dut();
            @(negedge CLK);
            EN = 1; TE = 1;
            @(posedge CLK); #2;

            #3;
            RESET = 1;
            #1;
            #1;

            check_outputs(ENCLK, 1'b0);
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
        $dumpvars(0,CLK, EN, RESET, TE, ENCLK, Q);
    end

endmodule
