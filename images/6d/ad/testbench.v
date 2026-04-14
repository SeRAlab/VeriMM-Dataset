`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg din;
    reg sclk;
    reg sync_n;
    wire [11:0] vout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .din(din),
        .sclk(sclk),
        .sync_n(sync_n),
        .vout(vout)
    );

    // Clock generation (10ns period)
    initial begin
        sclk = 0;
        forever #5 sclk = ~sclk;
    end

        task reset_dut;

        begin
            sync_n = 1;
            din = 0;
            repeat(5) @(posedge sclk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Sending 12'h000", test_num);
            reset_dut();
            spi_shift_12(12'h000);
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Sending 12'hFFF", test_num);
            reset_dut();
            spi_shift_12(12'hFFF);
            #1;

            check_outputs(12'hFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Sending 12'hA5A", test_num);
            reset_dut();
            spi_shift_12(12'hA5A);
            #1;

            check_outputs(12'hA5A);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Sending 12'h5A5", test_num);
            reset_dut();
            spi_shift_12(12'h5A5);
            #1;

            check_outputs(12'h5A5);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Sending 12'h800", test_num);
            reset_dut();
            spi_shift_12(12'h800);
            #1;

            check_outputs(12'h800);
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
        input [11:0] expected_vout;
        begin
            if (expected_vout === (expected_vout ^ vout ^ expected_vout)) begin
                $display("PASS");
                $display("  Outputs: vout=%h",
                         vout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: vout=%h",
                         expected_vout);
                $display("  Got:      vout=%h",
                         vout);
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
        $dumpvars(0,din, sclk, sync_n, vout);
    end

endmodule
