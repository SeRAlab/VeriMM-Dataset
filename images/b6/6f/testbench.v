`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    wire baud;
    wire baud16;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .baud(baud),
        .baud16(baud16)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            @(negedge clk);
            @(negedge clk);
            rst = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            repeat (5) @(negedge clk);

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            repeat (50) @(negedge clk);



            #1;




            check_outputs(baud, baud16);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            repeat (500) @(negedge clk);

            if (baud == 1'b1)
                #1;

                check_outputs(1'b1, 1'b1);
            else
                #1;

                check_outputs(1'b0, baud16);
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
        input expected_baud;
        input expected_baud16;
        begin
            if (expected_baud === (expected_baud ^ baud ^ expected_baud) &&
                expected_baud16 === (expected_baud16 ^ baud16 ^ expected_baud16)) begin
                $display("PASS");
                $display("  Outputs: baud=%b, baud16=%b",
                         baud, baud16);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: baud=%b, baud16=%b",
                         expected_baud, expected_baud16);
                $display("  Got:      baud=%b, baud16=%b",
                         baud, baud16);
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
        $dumpvars(0,clk, rst, baud, baud16);
    end

endmodule
