`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    wire probe_out0;
    wire probe_out1;
    wire probe_out2;
    wire probe_out3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .probe_out0(probe_out0),
        .probe_out1(probe_out1),
        .probe_out2(probe_out2),
        .probe_out3(probe_out3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Initial state check after first rising edge...");
            test_num = 1;
            reset_dut();


            #1;



            check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Stability check after second rising edge...");
            test_num = 2;
            reset_dut();
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Check after 10 clock cycles...");
            test_num = 3;
            reset_dut();
            repeat (10) @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Mid-cycle sampling (checking register hold)...");
            test_num = 4;
            @(posedge clk);
            #7;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
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
        input expected_probe_out0;
        input expected_probe_out1;
        input expected_probe_out2;
        input expected_probe_out3;
        begin
            if (expected_probe_out0 === (expected_probe_out0 ^ probe_out0 ^ expected_probe_out0) &&
                expected_probe_out1 === (expected_probe_out1 ^ probe_out1 ^ expected_probe_out1) &&
                expected_probe_out2 === (expected_probe_out2 ^ probe_out2 ^ expected_probe_out2) &&
                expected_probe_out3 === (expected_probe_out3 ^ probe_out3 ^ expected_probe_out3)) begin
                $display("PASS");
                $display("  Outputs: probe_out0=%b, probe_out1=%b, probe_out2=%b, probe_out3=%b",
                         probe_out0, probe_out1, probe_out2, probe_out3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: probe_out0=%b, probe_out1=%b, probe_out2=%b, probe_out3=%b",
                         expected_probe_out0, expected_probe_out1, expected_probe_out2, expected_probe_out3);
                $display("  Got:      probe_out0=%b, probe_out1=%b, probe_out2=%b, probe_out3=%b",
                         probe_out0, probe_out1, probe_out2, probe_out3);
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
        $dumpvars(0,clk, probe_out0, probe_out1, probe_out2, probe_out3);
    end

endmodule
