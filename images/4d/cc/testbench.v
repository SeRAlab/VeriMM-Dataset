`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Ram_STB;
    reg clk;
    wire Ram_ACK;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Ram_STB(Ram_STB),
        .clk(clk),
        .Ram_ACK(Ram_ACK)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("\nResetting DUT...");
            Ram_STB = 0;
            repeat (2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Normal Operation (3+ cycles)", test_num);
            reset_dut();

            Ram_STB = 1;


            repeat (4) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Strobe de-asserted early (2 cycles)", test_num);
            reset_dut();

            Ram_STB = 1;
            repeat (2) @(posedge clk);
            Ram_STB = 0;
            repeat (2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: No Strobe activation", test_num);
            reset_dut();

            Ram_STB = 0;
            repeat (5) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Recovery after interrupted strobe", test_num);
            reset_dut();


            Ram_STB = 1;
            repeat (1) @(posedge clk);
            Ram_STB = 0;
            repeat (2) @(posedge clk);


            Ram_STB = 1;
            repeat (4) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Continuous assertion check", test_num);
            reset_dut();

            Ram_STB = 1;
            repeat (10) @(posedge clk);
            #1;
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
        input expected_Ram_ACK;
        begin
            if (expected_Ram_ACK === (expected_Ram_ACK ^ Ram_ACK ^ expected_Ram_ACK)) begin
                $display("PASS");
                $display("  Outputs: Ram_ACK=%b",
                         Ram_ACK);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Ram_ACK=%b",
                         expected_Ram_ACK);
                $display("  Got:      Ram_ACK=%b",
                         Ram_ACK);
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
        $dumpvars(0,Ram_STB, clk, Ram_ACK);
    end

endmodule
