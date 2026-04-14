`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] D;
    reg EI;
    reg clk;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .EI(EI),
        .clk(clk),
        .Q(Q)
    );

        task reset_dut;

        begin
            clk = 0;
            EI = 0;
            D = 8'h00;
            #10;

            D = 8'h00;
            EI = 1;
            clk_pulse();
            EI = 0;
        end
        endtask
    task clk_pulse;

        begin
            #5 clk = 1;
            #5 clk = 0;
            #5;
        end
        endtask

    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %03d: Basic Load (EI=1, D=8'hA5)", test_num);
            D = 8'hA5;
            EI = 1;
            clk_pulse();
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %03d: Hold Value (EI=0, D=8'hFF)", test_num);
            D = 8'hFF;
            EI = 0;
            clk_pulse();
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %03d: Hold then Update", test_num);

            D = 8'h11;
            EI = 0;
            clk_pulse();

            D = 8'h22;
            EI = 1;
            clk_pulse();
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %03d: No clock edge check", test_num);

            D = 8'hAA;
            EI = 1;
            clk_pulse();

            D = 8'hBB;
            #10;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %03d: Multiple clock cycles with EI toggling", test_num);

            D = 8'hDE; EI = 1; clk_pulse();
            D = 8'hAD; EI = 0; clk_pulse();
            D = 8'hBE; EI = 1; clk_pulse();
            D = 8'hEF; EI = 0; clk_pulse();

            #1;


            check_outputs(8'hBE);
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
        $dumpvars(0,D, EI, clk, Q);
    end

endmodule
