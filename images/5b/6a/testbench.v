`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clock;
    reg E;
    reg L;
    reg [7:0] R;
    reg up_down;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clock(Clock),
        .E(E),
        .L(L),
        .R(R),
        .up_down(up_down),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        Clock = 0;
        forever #5 Clock = ~Clock;
    end

        task reset_dut;

        begin
            @(negedge Clock);
            L = 1;
            R = 8'h00;
            E = 0;
            up_down = 0;
            @(negedge Clock);
            L = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(negedge Clock);
            L = 1;
            R = 8'hA5;
            @(posedge Clock);
            #1;
            $display("Test %0d: Load value 8'hA5", test_num);
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(negedge Clock);
            L = 0;
            E = 1;
            up_down = 1;
            repeat(5) @(posedge Clock);
            #1;
            $display("Test %0d: Count up 5 times from 0", test_num);
            #1;

            check_outputs(8'h05);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();

            @(negedge Clock);
            L = 1; R = 8'h0A;
            @(posedge Clock);

            @(negedge Clock);
            L = 0; E = 1; up_down = 0;
            repeat(3) @(posedge Clock);
            #1;
            $display("Test %0d: Count down 3 times from 10", test_num);
            #1;

            check_outputs(8'h07);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(negedge Clock);
            L = 1; R = 8'h55;
            @(posedge Clock);
            @(negedge Clock);
            L = 0; E = 0; up_down = 1;
            repeat(4) @(posedge Clock);
            #1;
            $display("Test %0d: Enable low (counter should hold 0x55)", test_num);
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(negedge Clock);
            L = 1; R = 8'hFF;
            @(posedge Clock);
            @(negedge Clock);
            L = 0; E = 1; up_down = 1;
            @(posedge Clock);
            #1;
            $display("Test %0d: Up count rollover FF to 00", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(negedge Clock);
            L = 0; E = 1; up_down = 0;
            @(posedge Clock);
            #1;
            $display("Test %0d: Down count underflow 00 to FF", test_num);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(negedge Clock);
            L = 1; R = 8'hCC;
            E = 1; up_down = 1;
            @(posedge Clock);
            #1;
            $display("Test %0d: Load priority over Enable", test_num);
            #1;

            check_outputs(8'hCC);
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
        input [7:0] expected_Q;
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
        $dumpvars(0,Clock, E, L, R, up_down, Q);
    end

endmodule
