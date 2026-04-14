`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] esignal;
    reg [15:0] osignal;
    wire [15:0] outsignal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .esignal(esignal),
        .osignal(osignal),
        .outsignal(outsignal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            esignal = 16'd0;
            osignal = 16'd0;
            repeat(5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Zero inputs...");
            reset_dut();
            esignal = 16'sd0;
            osignal = 16'sd0;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(16'sd0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: No reference (esignal=0)...");
            reset_dut();
            esignal = 16'sd0;
            osignal = 16'sd1000;
            repeat(50) @(posedge clk);
            #1;

            check_outputs(16'sd1000);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("Running testcase003: Convergence (Perfect Echo)...");
            reset_dut();

            for (i = 0; i < 1000; i = i + 1) begin
                esignal = (i % 4 < 2) ? 16'sd4000 : -16'sd4000;
                osignal = esignal;
                @(posedge clk);
            end


            if (outsignal < 100 && outsignal > -100)
                #1;

                check_outputs(outsignal);
            else
                #1;

                check_outputs(16'sd0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Signal with no correlation...");
            reset_dut();
            esignal = 16'sd0;
            osignal = 16'sd500;
            repeat(100) @(posedge clk);
            #1;

            check_outputs(16'sd500);
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
        input [15:0] expected_outsignal;
        begin
            if (expected_outsignal === (expected_outsignal ^ outsignal ^ expected_outsignal)) begin
                $display("PASS");
                $display("  Outputs: outsignal=%h",
                         outsignal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outsignal=%h",
                         expected_outsignal);
                $display("  Got:      outsignal=%h",
                         outsignal);
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
        $dumpvars(0,clk, esignal, osignal, outsignal);
    end

endmodule
