`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    wire clk1;
    wire clk2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk(Clk),
        .clk1(clk1),
        .clk2(clk2)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin


            @(posedge Clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Checking clk1 toggle at 600 cycles", test_num);
            reset_dut();

            repeat(600) @(posedge Clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Checking clk1 toggle at 1200 cycles", test_num);
            reset_dut();
            repeat(1200) @(posedge Clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Checking clk2 toggle at 4096 cycles", test_num);
            reset_dut();
            repeat(4096) @(posedge Clk);
            #1;




            #1;





            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Checking clk2 toggle at 8192 cycles", test_num);
            reset_dut();
            repeat(8192) @(posedge Clk);
            #1;



            #1;




            check_outputs(1'b1, 1'b0);
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
        input expected_clk1;
        input expected_clk2;
        begin
            if (expected_clk1 === (expected_clk1 ^ clk1 ^ expected_clk1) &&
                expected_clk2 === (expected_clk2 ^ clk2 ^ expected_clk2)) begin
                $display("PASS");
                $display("  Outputs: clk1=%b, clk2=%b",
                         clk1, clk2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk1=%b, clk2=%b",
                         expected_clk1, expected_clk2);
                $display("  Got:      clk1=%b, clk2=%b",
                         clk1, clk2);
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
        $dumpvars(0,Clk, clk1, clk2);
    end

endmodule
