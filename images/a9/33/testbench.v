`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ci;
    reg clk;
    reg [5:0] din;
    wire dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ci(ci),
        .clk(clk),
        .din(din),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ci = 1;
            din = 6'h3F;
            @(posedge clk);
            #1;
            ci = 0;
            @(posedge clk);
            #1;
            test_num = test_num + 1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            din = 6'b000000;
            ci = 0;
            @(posedge clk);
            #1;
            $display("Testcase 001: Transition PLAY -> OVER via din=0");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            din = 6'b000000;
            @(posedge clk);
            #1;

            din = 6'b000001;
            @(posedge clk);
            #1;
            $display("Testcase 002: Transition OVER -> PLAY via din=1");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            din = 6'b111111;
            ci = 1;
            @(posedge clk);
            #1;
            $display("Testcase 003: Force OVER using ci=1 from PLAY");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            din = 0;
            @(posedge clk);
            #1;
            din = 0;
            @(posedge clk);
            #1;
            $display("Testcase 004: Maintain OVER state while din=0");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            din = 6'b101010;
            ci = 0;
            @(posedge clk);
            #1;
            $display("Testcase 005: Maintain PLAY state while din>0 and ci=0");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            din = 0;
            @(posedge clk);
            #1;
            din = 6'b111111;
            ci = 1;
            @(posedge clk);
            #1;
            $display("Testcase 006: ci priority over din transition in OVER");
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
        input expected_dout;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%b",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%b",
                         expected_dout);
                $display("  Got:      dout=%b",
                         dout);
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
        $dumpvars(0,ci, clk, din, dout);
    end

endmodule
