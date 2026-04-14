`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] baud;
    reg clk;
    reg resetq;
    reg restart;
    wire ser_clk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .baud(baud),
        .clk(clk),
        .resetq(resetq),
        .restart(restart),
        .ser_clk(ser_clk)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            resetq = 0;
            baud = 32'd0;
            restart = 0;
            repeat(2) @(posedge clk);
            #1 resetq = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Baud = 4 terminal count pulse", test_num);
            reset_dut();
            baud = 32'd4;

            repeat(3) @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Baud = 16 terminal count pulse", test_num);
            reset_dut();
            baud = 32'd16;
            repeat(15) @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Restart functionality", test_num);
            reset_dut();
            baud = 32'd10;
            repeat(5) @(posedge clk);
            restart = 1;
            @(posedge clk);
            restart = 0;

            repeat(9) @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Output low during counting", test_num);
            reset_dut();
            baud = 32'd20;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset state check", test_num);
            reset_dut();
            resetq = 0;
            baud = 32'd4;
            repeat(10) @(posedge clk);
            #1;
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
        input expected_ser_clk;
        begin
            if (expected_ser_clk === (expected_ser_clk ^ ser_clk ^ expected_ser_clk)) begin
                $display("PASS");
                $display("  Outputs: ser_clk=%b",
                         ser_clk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ser_clk=%b",
                         expected_ser_clk);
                $display("  Got:      ser_clk=%b",
                         ser_clk);
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
        $dumpvars(0,baud, clk, resetq, restart, ser_clk);
    end

endmodule
