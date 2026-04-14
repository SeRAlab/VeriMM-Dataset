`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] mdor_next;
    reg mdor_we;
    wire [31:0] mdor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .mdor_next(mdor_next),
        .mdor_we(mdor_we),
        .mdor(mdor)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            mdor_we <= 1;
            mdor_next <= 32'h0;
            @(posedge clk);
            #1;
            mdor_we <= 0;
            mdor_next <= 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write Operation", test_num);
            reset_dut();

            mdor_next <= 32'hA5A5A5A5;
            mdor_we <= 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hA5A5A5A5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write Enable Low Inhibition", test_num);
            reset_dut();


            mdor_next <= 32'h12345678;
            mdor_we <= 1;
            @(posedge clk);
            #1;


            mdor_next <= 32'hFFFFFFFF;
            mdor_we <= 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwriting Existing Data", test_num);
            reset_dut();


            mdor_next <= 32'hCAFEFACE;
            mdor_we <= 1;
            @(posedge clk);
            #1;


            mdor_next <= 32'hBEEFCAFE;
            mdor_we <= 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hBEEFCAFE);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Full Bit Width Test", test_num);
            reset_dut();

            mdor_next <= 32'hFFFFFFFF;
            mdor_we <= 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Retention over multiple cycles", test_num);
            reset_dut();

            mdor_next <= 32'h55AA55AA;
            mdor_we <= 1;
            @(posedge clk);
            #1;

            mdor_we <= 0;
            mdor_next <= 32'h0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(32'h55AA55AA);
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
        input [31:0] expected_mdor;
        begin
            if (expected_mdor === (expected_mdor ^ mdor ^ expected_mdor)) begin
                $display("PASS");
                $display("  Outputs: mdor=%h",
                         mdor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mdor=%h",
                         expected_mdor);
                $display("  Got:      mdor=%h",
                         mdor);
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
        $dumpvars(0,clk, mdor_next, mdor_we, mdor);
    end

endmodule
