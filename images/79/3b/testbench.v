`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg m;
    wire [3:0] Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .m(m),
        .Z(Z)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            m = 0;
            if (current_state === x) current_state = 0;
            while (current_state != 0) begin
                step_state();
            end
            #1;
        end
        endtask
    task step_state;

        begin
            @(posedge clk);
            #1;
            current_state = (current_state + 1) % 4;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            m = 0;
            #2;
            $display("Testcase 001: Checking S0 with m=0");
            #1;

            check_outputs(4'hB);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            m = 1;
            #2;
            $display("Testcase 002: Checking S0 with m=1");
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            step_state();
            m = 0;
            #2;
            $display("Testcase 003: Checking S1 with m=0");
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            step_state();
            m = 1;
            #2;
            $display("Testcase 004: Checking S1 with m=1");
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            step_state();
            step_state();
            m = 0;
            #2;
            $display("Testcase 005: Checking S2 with m=0");
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            step_state();
            step_state();
            m = 1;
            #2;
            $display("Testcase 006: Checking S2 with m=1");
            #1;

            check_outputs(4'hE);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            repeat(3) step_state();
            m = 0;
            #2;
            $display("Testcase 007: Checking S3 with m=0");
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            repeat(3) step_state();
            m = 1;
            #2;
            $display("Testcase 008: Checking S3 with m=1");
            #1;

            check_outputs(4'hD);
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
        input [3:0] expected_Z;
        begin
            if (expected_Z === (expected_Z ^ Z ^ expected_Z)) begin
                $display("PASS");
                $display("  Outputs: Z=%h",
                         Z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Z=%h",
                         expected_Z);
                $display("  Got:      Z=%h",
                         Z);
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
        $dumpvars(0,clk, m, Z);
    end

endmodule
