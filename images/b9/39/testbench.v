`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg rst_n;
    wire VGND;
    wire VPWR;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .rst_n(rst_n),
        .VGND(VGND),
        .VPWR(VPWR)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable <= 0;
            rst_n <= 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            rst_n <= 0;
            enable <= 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            rst_n <= 1;
            enable <= 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            rst_n <= 1;
            enable <= 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            rst_n <= 1;
            enable <= 1;
            @(posedge clk);
            #1;

            rst_n <= 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            rst_n <= 1;
            enable <= 1;
            @(posedge clk);
            #1;
            enable <= 0;
            @(posedge clk);
            #1;
            enable <= 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
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
        input expected_VGND;
        input expected_VPWR;
        begin
            if (expected_VGND === (expected_VGND ^ VGND ^ expected_VGND) &&
                expected_VPWR === (expected_VPWR ^ VPWR ^ expected_VPWR)) begin
                $display("PASS");
                $display("  Outputs: VGND=%b, VPWR=%b",
                         VGND, VPWR);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: VGND=%b, VPWR=%b",
                         expected_VGND, expected_VPWR);
                $display("  Got:      VGND=%b, VPWR=%b",
                         VGND, VPWR);
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
        $dumpvars(0,clk, enable, rst_n, VGND, VPWR);
    end

endmodule
