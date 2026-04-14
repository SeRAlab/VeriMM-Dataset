`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg D;
    reg RESET_B;
    reg SET_B;
    wire Q;
    wire Q_B;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .D(D),
        .RESET_B(RESET_B),
        .SET_B(SET_B),
        .Q(Q),
        .Q_B(Q_B)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RESET_B = 0;
            SET_B = 1;
            D = 0;
            #12;
            RESET_B = 1;
            #5;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %03d: Asynchronous Reset (RESET_B=0)", test_num);

            RESET_B = 0;
            SET_B = 1;
            D = 1;
            #5;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %03d: Asynchronous Set (SET_B=0)", test_num);

            RESET_B = 1;
            SET_B = 0;
            D = 0;
            #5;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %03d: Synchronous Load D=1", test_num);
            RESET_B = 1;
            SET_B = 1;
            D = 1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %03d: Synchronous Load D=0", test_num);
            RESET_B = 1;
            SET_B = 1;
            D = 1;
            @(posedge CLK);
            #2;
            D = 0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %03d: Both SET_B and RESET_B Low (Reset Priority)", test_num);
            RESET_B = 0;
            SET_B = 0;
            D = 1;
            #5;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %03d: Verify Data Stability (No Clock Edge)", test_num);
            RESET_B = 1;
            SET_B = 1;
            D = 1;
            @(posedge CLK);
            #2;
            D = 0;
            #2;
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
        input expected_Q;
        input expected_Q_B;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_Q_B === (expected_Q_B ^ Q_B ^ expected_Q_B)) begin
                $display("PASS");
                $display("  Outputs: Q=%b, Q_B=%b",
                         Q, Q_B);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b, Q_B=%b",
                         expected_Q, expected_Q_B);
                $display("  Got:      Q=%b, Q_B=%b",
                         Q, Q_B);
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
        $dumpvars(0,CLK, D, RESET_B, SET_B, Q, Q_B);
    end

endmodule
