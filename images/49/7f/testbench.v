`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg FlagIn_clkA;
    reg clkA;
    reg clkB;
    reg rst_n;
    wire FlagOut_clkB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .FlagIn_clkA(FlagIn_clkA),
        .clkA(clkA),
        .clkB(clkB),
        .rst_n(rst_n),
        .FlagOut_clkB(FlagOut_clkB)
    );

    // Clock generation (10ns period)
    initial begin
        clkA = 0;
        forever #5 clkA = ~clkA;
    end

        task reset_dut;

        begin
            rst_n = 0;
            FlagIn_clkA = 0;
            pulse_captured = 0;
            repeat (5) @(posedge clkA);
            #1 rst_n = 1;
            repeat (5) @(posedge clkB);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Initial Reset State", test_num);
            reset_dut();
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        integer timeout;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pulse on Rising Edge", test_num);
            reset_dut();

            @(posedge clkA);
            #1 FlagIn_clkA = 1;


            pulse_captured = 0;
            timeout = 0;
            while (timeout < 20) begin
                @(posedge clkB);
                if (FlagOut_clkB) pulse_captured = 1;
                timeout = timeout + 1;
            end

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        integer timeout;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pulse on Falling Edge", test_num);
            reset_dut();


            @(posedge clkA);
            #1 FlagIn_clkA = 1;
            repeat (15) @(posedge clkB);


            @(posedge clkA);
            #1 FlagIn_clkA = 0;

            pulse_captured = 0;
            timeout = 0;
            while (timeout < 20) begin
                @(posedge clkB);
                if (FlagOut_clkB) pulse_captured = 1;
                timeout = timeout + 1;
            end

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        integer pulse_count;
        integer timeout;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Sequential Pulses", test_num);
            reset_dut();
            pulse_count = 0;


            @(posedge clkA); #1 FlagIn_clkA = 1;


            timeout = 0;
            while (timeout < 20) begin
                @(posedge clkB);
                if (FlagOut_clkB) begin
                    pulse_count = pulse_count + 1;
                    break;
                end
                timeout = timeout + 1;
            end
            repeat(5) @(posedge clkB);


            @(posedge clkA); #1 FlagIn_clkA = 0;


            timeout = 0;
            while (timeout < 20) begin
                @(posedge clkB);
                if (FlagOut_clkB) begin
                    pulse_count = pulse_count + 1;
                    break;
                end
                timeout = timeout + 1;
            end

            pulse_captured = (pulse_count == 2);
            #1;

            check_outputs(1'b1);
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
        input expected_FlagOut_clkB;
        begin
            if (expected_FlagOut_clkB === (expected_FlagOut_clkB ^ FlagOut_clkB ^ expected_FlagOut_clkB)) begin
                $display("PASS");
                $display("  Outputs: FlagOut_clkB=%b",
                         FlagOut_clkB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: FlagOut_clkB=%b",
                         expected_FlagOut_clkB);
                $display("  Got:      FlagOut_clkB=%b",
                         FlagOut_clkB);
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
        $dumpvars(0,FlagIn_clkA, clkA, clkB, rst_n, FlagOut_clkB);
    end

endmodule
