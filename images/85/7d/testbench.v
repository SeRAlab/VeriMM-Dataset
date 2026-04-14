`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg D;
    reg G;
    reg R;
    reg S;
    wire Q;
    wire QN;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .G(G),
        .R(R),
        .S(S),
        .Q(Q),
        .QN(QN)
    );

    // Clock generation (10ns period)
    initial begin
        G = 0;
        forever #5 G = ~G;
    end

        task reset_dut;

        begin
            R = 1; S = 0; D = 0;
            @(posedge G);
            #1;
            R = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(negedge G);
            S = 1; R = 0; D = 0;
            @(posedge G);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            @(negedge G);
            S = 0; R = 0; D = 1;
            @(posedge G);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            @(negedge G);
            S = 0; R = 0; D = 1;
            @(posedge G);
            #1;

            @(negedge G);
            D = 0;
            @(posedge G);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            @(negedge G);
            R = 1; S = 1; D = 1;
            @(posedge G);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            @(negedge G);
            D = 1; R = 0; S = 0;
            #2;

            if (Q !== 1'b0) $display("Error: Output changed before posedge G");
            @(posedge G);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();

            @(negedge G); S = 1; R = 0; @(posedge G); #1;

            @(negedge G); S = 0; R = 0; D = 0; @(posedge G); #1;

            @(negedge G); D = 1; @(posedge G); #1;

            @(negedge G); R = 1; @(posedge G); #1;
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
        input expected_Q;
        input expected_QN;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_QN === (expected_QN ^ QN ^ expected_QN)) begin
                $display("PASS");
                $display("  Outputs: Q=%b, QN=%b",
                         Q, QN);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b, QN=%b",
                         expected_Q, expected_QN);
                $display("  Got:      Q=%b, QN=%b",
                         Q, QN);
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
        $dumpvars(0,D, G, R, S, Q, QN);
    end

endmodule
