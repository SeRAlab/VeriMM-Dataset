`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg C;
    reg D;
    reg E;
    reg R;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .C(C),
        .D(D),
        .E(E),
        .R(R),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        C = 0;
        forever #5 C = ~C;
    end

        task reset_dut;

        begin
            R = 1;
            E = 1;
            D = 0;
            @(negedge C);
            #1;
            R = 0;
            E = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test Case %03d: Load 1 (E=1, R=0, D=1)", test_num);
            D = 1;
            E = 1;
            R = 0;
            @(negedge C);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test Case %03d: Reset Priority (E=1, R=1, D=1)", test_num);
            D = 1;
            E = 1;
            R = 1;
            @(negedge C);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test Case %03d: Enable Disable (Hold logic)", test_num);

            D = 1; E = 1; R = 0;
            @(negedge C);
            #1;

            E = 0; D = 0;
            @(negedge C);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test Case %03d: Load 0 (E=1, R=0, D=0)", test_num);

            D = 1; E = 1; R = 0;
            @(negedge C);
            #1;

            D = 0; E = 1; R = 0;
            @(negedge C);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test Case %03d: Negative Edge Sensitivity Check", test_num);
            D = 1; E = 1; R = 0;
            @(posedge C);
            #1;
            if (Q === 1'b1) begin
                $display("FAIL: Q changed on positive edge!");
                fail_count = fail_count + 1;
            end else begin
                @(negedge C);
                #2;
                #1;

                check_outputs(1'b1);
            end
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test Case %03d: Reset while Q=1", test_num);

            D = 1; E = 1; R = 0;
            @(negedge C);
            #1;

            R = 1;
            @(negedge C);
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
        $dumpvars(0,C, D, E, R, Q);
    end

endmodule
