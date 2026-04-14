`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] D;
    reg LD;
    reg SH;
    wire [15:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .LD(LD),
        .SH(SH),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        LD = 0;
        forever #5 LD = ~LD;
    end

        task reset_dut;

        begin
            D = 16'h0000;
            LD = 1;
            SH = 0;
            pulse_sh();
            LD = 0;
        end
        endtask
    task pulse_sh;

        begin
            #5 SH = 1;
            #5 SH = 0;
            #5;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            D = 16'hAAAA;
            LD = 1;
            pulse_sh();
            LD = 0;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            D = 16'h8000;
            LD = 1;
            pulse_sh();

            LD = 0;
            pulse_sh();
            #1;

            check_outputs(16'h4000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            D = 16'h0001;
            LD = 1;
            pulse_sh();

            LD = 0;
            pulse_sh();
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            reset_dut();
            D = 16'hF000;
            LD = 1;
            pulse_sh();
            LD = 0;
            for(i=0; i<4; i=i+1) begin
                pulse_sh();
            end
            #1;

            check_outputs(16'h0F00);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            reset_dut();
            D = 16'hFFFF;
            LD = 1;
            pulse_sh();
            LD = 0;
            for(i=0; i<16; i=i+1) begin
                pulse_sh();
            end
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            D = 16'h1234;
            LD = 1;
            pulse_sh();
            LD = 0;
            D = 16'hFFFF;
            #20;
            #1;

            check_outputs(16'h1234);
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
        input [15:0] expected_Q;
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
        $dumpvars(0,D, LD, SH, Q);
    end

endmodule
