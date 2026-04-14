`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg in;
    reg modet;
    wire mode;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .modet(modet),
        .mode(mode)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            modet = 0;
            in = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Load '1' into register", test_num);
            reset_dut();

            modet = 1;
            in = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Load '0' into register", test_num);
            reset_dut();

            modet = 1;
            in = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Disable update (modet=0) - Hold '1'", test_num);
            reset_dut();


            modet = 1; in = 1;
            @(posedge clk);
            #2;


            modet = 0; in = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Disable update (modet=0) - Hold '0'", test_num);
            reset_dut();


            modet = 1; in = 0;
            @(posedge clk);
            #2;


            modet = 0; in = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Consecutive updates (Toggle)", test_num);
            reset_dut();


            modet = 1; in = 1;
            @(posedge clk);
            #2;


            modet = 1; in = 0;
            @(posedge clk);
            #2;


            modet = 1; in = 1;
            @(posedge clk);
            #2;

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
        input expected_mode;
        begin
            if (expected_mode === (expected_mode ^ mode ^ expected_mode)) begin
                $display("PASS");
                $display("  Outputs: mode=%b",
                         mode);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mode=%b",
                         expected_mode);
                $display("  Got:      mode=%b",
                         mode);
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
        $dumpvars(0,clk, in, modet, mode);
    end

endmodule
