`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg D;
    reg KAPWR;
    reg NOTIFIER_REG;
    reg SET_ASYNC;
    reg SLEEP_B;
    reg VGND;
    reg VPWR;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .KAPWR(KAPWR),
        .NOTIFIER_REG(NOTIFIER_REG),
        .SET_ASYNC(SET_ASYNC),
        .SLEEP_B(SLEEP_B),
        .VGND(VGND),
        .VPWR(VPWR),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        SET_ASYNC = 0;
        forever #5 SET_ASYNC = ~SET_ASYNC;
    end

        task reset_dut;

        begin
            D = 0;
            KAPWR = 1;
            NOTIFIER_REG = 0;
            SLEEP_B = 1;
            VGND = 0;
            VPWR = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Normal Operation - D=1, Power ON", test_num);
            reset_dut();
            D = 1;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Normal Operation - D=0, Power ON", test_num);
            reset_dut();
            D = 0;
            #10;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Asynchronous Set Override (SET_ASYNC=1)", test_num);
            reset_dut();
            D = 0;
            #5;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Low Power Mode (SLEEP_B=0)", test_num);
            reset_dut();
            SLEEP_B = 0;
            D = 1;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Power Loss (VPWR=0)", test_num);
            reset_dut();
            VPWR = 0;
            D = 1;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Keep-Alive Power Loss (KAPWR=0)", test_num);
            reset_dut();
            KAPWR = 0;
            D = 1;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Ground Potential Shift (VGND=1)", test_num);
            reset_dut();
            VGND = 1;
            D = 1;
            #10;
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
        $dumpvars(0,D, KAPWR, NOTIFIER_REG, SET_ASYNC, SLEEP_B, VGND, VPWR, Q);
    end

endmodule
