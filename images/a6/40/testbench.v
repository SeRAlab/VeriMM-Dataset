`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    wire clk;
    wire en;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .en(en)
    );

        task reset_dut;

        begin
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running testcase001: Checking first rising edge...");
            reset_dut();
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running testcase002: Checking second rising edge...");
            reset_dut();
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running testcase003: Checking third rising edge...");
            reset_dut();
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running testcase004: Checking fourth rising edge...");
            reset_dut();
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running testcase005: Checking fifth rising edge...");
            reset_dut();
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b1);
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
        input expected_clk;
        input expected_en;
        begin
            if (expected_clk === (expected_clk ^ clk ^ expected_clk) &&
                expected_en === (expected_en ^ en ^ expected_en)) begin
                $display("PASS");
                $display("  Outputs: clk=%b, en=%b",
                         clk, en);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk=%b, en=%b",
                         expected_clk, expected_en);
                $display("  Got:      clk=%b, en=%b",
                         clk, en);
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
        $dumpvars(0,clk, en);
    end

endmodule
