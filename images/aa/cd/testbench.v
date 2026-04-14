`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg D;
    reg EN;
    reg TE;
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
        .Q(Q)
    );

        task reset_dut;

        begin
            CLK = 0;
            D = 0;
            EN = 1;
            TE = 1;
            #10 CLK = 1;
            #10 CLK = 0;
            EN = 0;
            TE = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            D = 1;
            EN = 1;
            TE = 1;
            #10 CLK = 1;
            #10 CLK = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            D = 1;
            EN = 0;
            TE = 1;
            #10 CLK = 1;
            #10 CLK = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            D = 1;
            EN = 1;
            TE = 0;
            #10 CLK = 1;
            #10 CLK = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            D = 1;
            EN = 0;
            TE = 0;
            #10 CLK = 1;
            #10 CLK = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;

            D = 1; EN = 1; TE = 1;
            #10 CLK = 1; #10 CLK = 0;

            D = 0; EN = 1; TE = 1;
            #10 CLK = 1;
            #10 CLK = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;

            D = 1; EN = 1; TE = 1;
            #10 CLK = 1; #10 CLK = 0;

            D = 0; EN = 0; TE = 1;
            #10 CLK = 1;
            #10 CLK = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;

            D = 1; EN = 1; TE = 1;
            #10 CLK = 1; #10 CLK = 0;

            D = 0; EN = 1; TE = 0;
            #10 CLK = 1;
            #10 CLK = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            EN = 1; TE = 1; D = 0;
            #10 CLK = 1; #5;
            D = 1;
            #5 CLK = 0;
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
        testcase007();
        testcase008();
        
        
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
        $dumpvars(0,CLK, D, EN, TE, Q);
    end

endmodule
