`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clk_ena;
    reg [17:0] dataa;
    reg [17:0] datab;
    wire [17:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clk_ena(clk_ena),
        .dataa(dataa),
        .datab(datab),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clk_ena <= 0;
            dataa <= 18'd0;
            datab <= 18'd0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Addition (ena=1)", test_num);
            reset_dut();
            dataa <= 18'd1000;
            datab <= 18'd2000;
            clk_ena <= 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(18'd3000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Clock Enable Inactive", test_num);
            reset_dut();


            dataa <= 18'h5;
            datab <= 18'h5;
            clk_ena <= 1;
            @(posedge clk);
            #1;


            dataa <= 18'hA;
            datab <= 18'hA;
            clk_ena <= 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(18'hA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max value rollover", test_num);
            reset_dut();
            dataa <= 18'h3FFFF;
            datab <= 18'h00001;
            clk_ena <= 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(18'h00000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable toggle", test_num);
            reset_dut();


            dataa <= 18'h12345;
            datab <= 18'h05432;
            clk_ena <= 0;
            @(posedge clk);
            #1;


            clk_ena <= 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(18'h17777);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero inputs", test_num);
            reset_dut();


            dataa <= 18'hFFFF;
            clk_ena <= 1;
            @(posedge clk);
            #1;


            dataa <= 18'd0;
            datab <= 18'd0;
            clk_ena <= 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(18'd0);
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
        input [17:0] expected_result;
        begin
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
        $dumpvars(0,clk, clk_ena, dataa, datab, result);
    end

endmodule
