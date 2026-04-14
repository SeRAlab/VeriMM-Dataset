`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg EN_write_0;
    reg write_0;
    wire read_0;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .EN_write_0(EN_write_0),
        .write_0(write_0),
        .read_0(read_0)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            EN_write_0 = 0;
            write_0 = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Write High");
            reset_dut();
            EN_write_0 = 1;
            write_0 = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Basic Write Low");
            reset_dut();

            EN_write_0 = 1;
            write_0 = 1;
            @(posedge CLK);
            #1;

            write_0 = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Write Enable (Hold 1)");
            reset_dut();

            EN_write_0 = 1;
            write_0 = 1;
            @(posedge CLK);
            #1;

            EN_write_0 = 0;
            write_0 = 0;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Write Enable (Hold 0)");
            reset_dut();

            EN_write_0 = 1;
            write_0 = 0;
            @(posedge CLK);
            #1;

            EN_write_0 = 0;
            write_0 = 1;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Multi-cycle Stability");
            reset_dut();
            EN_write_0 = 1;
            write_0 = 1;
            @(posedge CLK);
            #1;
            EN_write_0 = 0;
            write_0 = 1;
            repeat(5) @(posedge CLK);
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
        input expected_read_0;
        begin
            if (expected_read_0 === (expected_read_0 ^ read_0 ^ expected_read_0)) begin
                $display("PASS");
                $display("  Outputs: read_0=%b",
                         read_0);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: read_0=%b",
                         expected_read_0);
                $display("  Got:      read_0=%b",
                         read_0);
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
        $dumpvars(0,CLK, EN_write_0, write_0, read_0);
    end

endmodule
