`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clock;
    reg E;
    reg [6:0] R;
    reg Resetn;
    wire [6:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clock(Clock),
        .E(E),
        .R(R),
        .Resetn(Resetn),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        Clock = 0;
        forever #5 Clock = ~Clock;
    end

        task reset_dut;

        begin
            Resetn = 0;
            E = 0;
            R = 0;
            @(posedge Clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Synchronous Reset", test_num);
            reset_dut();

            Resetn = 0;
            E = 1;
            R = 7'h5A;
            @(posedge Clock);
            #1;
            #1;

            check_outputs(7'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Load (E=1, Resetn=1)", test_num);
            reset_dut();
            Resetn = 1;
            E = 1;
            R = 7'h3C;
            @(posedge Clock);
            #1;
            #1;

            check_outputs(7'h3C);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data Hold (E=0)", test_num);
            reset_dut();

            Resetn = 1;
            E = 1;
            R = 7'h12;
            @(posedge Clock);
            #1;

            E = 0;
            R = 7'h7F;
            @(posedge Clock);
            #1;
            #1;

            check_outputs(7'h12);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset Priority", test_num);
            reset_dut();

            Resetn = 1;
            E = 1;
            R = 7'h44;
            @(posedge Clock);
            #1;

            Resetn = 0;
            E = 1;
            R = 7'h22;
            @(posedge Clock);
            #1;
            #1;

            check_outputs(7'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Full Bit Width Load", test_num);
            reset_dut();
            Resetn = 1;
            E = 1;
            R = 7'h7F;
            @(posedge Clock);
            #1;
            #1;

            check_outputs(7'h7F);
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
        input [6:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
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
        $dumpvars(0,Clock, E, R, Resetn, Q);
    end

endmodule
