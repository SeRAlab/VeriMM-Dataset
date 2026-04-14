`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg increment;
    reg increment_clk;
    reg [15:0] reg_addr;
    reg reg_clk;
    reg reg_wr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .increment(increment),
        .increment_clk(increment_clk),
        .reg_addr(reg_addr),
        .reg_clk(reg_clk),
        .reg_wr(reg_wr)
    );

    // Clock generation (10ns period)
    initial begin
        increment_clk = 0;
        forever #5 increment_clk = ~increment_clk;
    end

        task reset_dut;

        begin
            @(posedge reg_clk);
            drive_en = 1;
            reg_wr = 1;
            reg_addr = 16'h0000;
            reg_data_out = 32'h0;
            @(posedge reg_clk);
            reg_wr = 0;
            drive_en = 0;
            increment = 0;
            repeat(2) @(posedge reg_clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            @(posedge increment_clk);
            increment = 1;
            repeat(10) @(posedge increment_clk);
            increment = 0;


            reg_wr = 0;
            reg_addr = 16'h0000;
            @(posedge reg_clk);
            #1;
            expected_value = 32'd10;
            #1;

            check_outputs();
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(posedge increment_clk);
            increment = 0;
            repeat(5) @(posedge increment_clk);

            reg_wr = 0;
            reg_addr = 16'h0000;
            @(posedge reg_clk);
            #1;
            expected_value = 32'd0;
            #1;

            check_outputs();
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            @(posedge increment_clk);
            increment = 1;
            repeat(5) @(posedge increment_clk);


            @(posedge reg_clk);
            reg_wr = 1;
            reg_addr = 16'h0000;
            drive_en = 1;
            reg_data_out = 32'h0;
            @(posedge reg_clk);
            reg_wr = 0;
            drive_en = 0;


            @(posedge reg_clk);
            #1;
            expected_value = 32'd0;
            #1;

            check_outputs();
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            @(posedge increment_clk);
            increment = 1;
            repeat(25) @(posedge increment_clk);
            increment = 0;
            repeat(5) @(posedge increment_clk);

            reg_wr = 0;
            reg_addr = 16'h0000;
            @(posedge reg_clk);
            #1;
            expected_value = 32'd25;
            #1;

            check_outputs();
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
        begin
            if () begin
                $display("PASS");
                $display("  Outputs: ",
                         );
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ",
                         );
                $display("  Got:      ",
                         );
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
        $dumpvars(0,increment, increment_clk, reg_addr, reg_clk, reg_wr);
    end

endmodule
