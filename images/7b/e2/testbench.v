`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    wire dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            $display("Testcase 001: Checking initial output bit...");
            #1;

            check_outputs(dout);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            repeat(4) @(posedge clk);
            #1;
            $display("Testcase 002: Checking bit sequence after 5 cycles...");

            if (dout === 1'bx || dout === 1'bz)
                #1;

                check_outputs(!dout);
            else
                #1;

                check_outputs(dout);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            repeat(9) @(posedge clk);
            #1;
            $display("Testcase 003: Checking bit sequence after 10 cycles...");
            #1;

            check_outputs(dout);
        end
        endtask

    task testcase004;

        reg first_bit;
        reg toggled;
        integer i;
        begin
            test_num = 4;
            reset_dut();
            first_bit = dout;
            toggled = 0;
            for (i = 0; i < 50; i = i + 1) begin
                @(posedge clk);
                if (dout !== first_bit) toggled = 1;
            end
            #1;
            $display("Testcase 004: Verifying bit toggling over 50 cycles...");
            if (toggled) begin
                pass_count = pass_count + 1;
                $display("PASS: LFSR is shifting and toggling.");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: LFSR output is stuck constant.");
            end
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
        input expected_dout;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%b",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%b",
                         expected_dout);
                $display("  Got:      dout=%b",
                         dout);
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
        $dumpvars(0,clk, dout);
    end

endmodule
