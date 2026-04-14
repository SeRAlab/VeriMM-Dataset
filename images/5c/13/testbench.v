`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg axi_clk;
    wire div_clk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .axi_clk(axi_clk),
        .div_clk(div_clk)
    );

    // Clock generation (10ns period)
    initial begin
        axi_clk = 0;
        forever #5 axi_clk = ~axi_clk;
    end

        task reset_dut;

        begin



            if ($time == 0) begin

                #0;
            end else begin
                @(negedge axi_clk);
                #1;
            end
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verifying first rising edge toggle (Expected: 1)", test_num);
            reset_dut();
            @(posedge axi_clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Verifying second rising edge toggle (Expected: 0)", test_num);
            reset_dut();
            @(posedge axi_clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Verifying third rising edge toggle (Expected: 1)", test_num);
            reset_dut();
            @(posedge axi_clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Verifying fourth rising edge toggle (Expected: 0)", test_num);
            reset_dut();
            @(posedge axi_clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Verifying state after 3 consecutive clock cycles", test_num);
            reset_dut();




            repeat(3) @(posedge axi_clk);
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
        input expected_div_clk;
        begin
            if (expected_div_clk === (expected_div_clk ^ div_clk ^ expected_div_clk)) begin
                $display("PASS");
                $display("  Outputs: div_clk=%b",
                         div_clk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: div_clk=%b",
                         expected_div_clk);
                $display("  Got:      div_clk=%b",
                         div_clk);
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
        $dumpvars(0,axi_clk, div_clk);
    end

endmodule
