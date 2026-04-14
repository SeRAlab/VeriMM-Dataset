`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg but_;
    reg clk;
    reg inta;
    reg rst;
    wire intr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .but_(but_),
        .clk(clk),
        .inta(inta),
        .rst(rst),
        .intr(intr)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            but_ = 0;
            inta = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Button Press (Rising Edge) Detection", test_num);
            reset_dut();
            but_ = 0;
            @(posedge clk);
            but_ = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: INTA Assertion Detection", test_num);
            reset_dut();
            inta = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Sustained Button Press (Should clear after 1 cycle if inta=0)", test_num);
            reset_dut();
            but_ = 1;
            @(posedge clk);
            but_ = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: INTA active while button is idle", test_num);
            reset_dut();
            but_ = 0;
            inta = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Concurrent Button Press and INTA", test_num);
            reset_dut();
            but_ = 1;
            inta = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1);
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
        input expected_intr;
        begin
            if (expected_intr === (expected_intr ^ intr ^ expected_intr)) begin
                $display("PASS");
                $display("  Outputs: intr=%b",
                         intr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: intr=%b",
                         expected_intr);
                $display("  Got:      intr=%b",
                         intr);
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
        $dumpvars(0,but_, clk, inta, rst, intr);
    end

endmodule
