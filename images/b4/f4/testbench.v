`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg req0;
    reg req1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .req0(req0),
        .req1(req1)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            req0 = 0;
            req1 = 0;
            @(posedge clk);
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Request 0 priority");
            reset_dut();
            req0 = 1;
            req1 = 0;
            @(posedge clk);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Request 1 (no req0)");
            reset_dut();
            req0 = 0;
            req1 = 1;
            @(posedge clk);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Simultaneous Request (req0 usually wins)");
            reset_dut();
            req0 = 1;
            req1 = 1;
            @(posedge clk);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Release req0 to return to Idle");
            reset_dut();
            req0 = 1;
            @(posedge clk);
            req0 = 0;
            @(posedge clk);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Handover from req0 to req1");
            reset_dut();
            req0 = 1;
            req1 = 1;
            @(posedge clk);
            req0 = 0;
            @(posedge clk);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Handover from req1 to req0");
            reset_dut();
            req0 = 0;
            req1 = 1;
            @(posedge clk);
            req0 = 1;
            req1 = 0;
            @(posedge clk);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Maintain grant while request is high");
            reset_dut();
            req1 = 1;
            @(posedge clk);
            req0 = 1;
            @(posedge clk);
            #1;

            check_outputs(2'b10);
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
        begin
            if () begin
                $display("PASS");
                $display("  Outputs: ",
                         );
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ",
                         );
                $display("  Got:      ",
                         );
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
        $dumpvars(0,clk, req0, req1);
    end

endmodule
