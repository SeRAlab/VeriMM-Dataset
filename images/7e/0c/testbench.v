`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Vin;
    reg Vth;
    reg clk;
    reg reset;
    wire rst_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Vin(Vin),
        .Vth(Vth),
        .clk(clk),
        .reset(reset),
        .rst_out(rst_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 0;
            Vin = 0;
            Vth = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %03d: Monitoring enabled, Vin < Vth (Under-voltage)", test_num);
            reset = 1;
            Vin = 0;
            Vth = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %03d: Monitoring enabled, Vin > Vth (Normal-voltage)", test_num);
            reset = 1;
            Vin = 1;
            Vth = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %03d: Monitoring enabled, Vin == Vth (Boundary condition)", test_num);
            reset = 1;
            Vin = 1;
            Vth = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %03d: Monitoring disabled (reset=0), Vin < Vth", test_num);
            reset = 0;
            Vin = 0;
            Vth = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %03d: Monitoring disabled (reset=0), Vin > Vth", test_num);
            reset = 0;
            Vin = 1;
            Vth = 0;
            @(posedge clk);
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
        input expected_rst_out;
        begin
            if (expected_rst_out === (expected_rst_out ^ rst_out ^ expected_rst_out)) begin
                $display("PASS");
                $display("  Outputs: rst_out=%b",
                         rst_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rst_out=%b",
                         expected_rst_out);
                $display("  Got:      rst_out=%b",
                         rst_out);
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
        $dumpvars(0,Vin, Vth, clk, reset, rst_out);
    end

endmodule
