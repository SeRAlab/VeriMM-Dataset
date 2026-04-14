`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_80;
    reg [3:0] d_80;
    reg rst_80;
    wire [3:0] q_80;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_80(clk_80),
        .d_80(d_80),
        .rst_80(rst_80),
        .q_80(q_80)
    );

    // Clock generation (10ns period)
    initial begin
        clk_80 = 0;
        forever #5 clk_80 = ~clk_80;
    end

        task reset_dut;

        begin
            rst_80 = 1;
            d_80 = 4'h0;
            @(posedge clk_80);
            #1;
            rst_80 = 0;
            @(posedge clk_80);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Initial Reset Verification", test_num);
            reset_dut();


            #1;



            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Capturing Data 4'hA (1010)", test_num);
            reset_dut();
            d_80 = 4'hA;
            @(posedge clk_80);
            #2;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Capturing Data 4'h5 (0101)", test_num);
            reset_dut();
            d_80 = 4'h5;
            @(posedge clk_80);
            #2;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Capturing All Ones 4'hF", test_num);
            reset_dut();
            d_80 = 4'hF;
            @(posedge clk_80);
            #2;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Reset Priority (Reset high while Data is present)", test_num);
            reset_dut();

            d_80 = 4'hC;
            @(posedge clk_80);
            #2;

            rst_80 = 1;
            d_80 = 4'h3;
            @(posedge clk_80);
            #2;

            #1;


            check_outputs(4'h0);
            rst_80 = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Continuous Data Stream", test_num);
            reset_dut();
            d_80 = 4'h1; @(posedge clk_80);
            d_80 = 4'h2; @(posedge clk_80);
            d_80 = 4'h3; @(posedge clk_80);
            d_80 = 4'h4; @(posedge clk_80);
            #2;
            #1;

            check_outputs(4'h4);
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
        input [3:0] expected_q_80;
        begin
            if (expected_q_80 === (expected_q_80 ^ q_80 ^ expected_q_80)) begin
                $display("PASS");
                $display("  Outputs: q_80=%h",
                         q_80);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q_80=%h",
                         expected_q_80);
                $display("  Got:      q_80=%h",
                         q_80);
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
        $dumpvars(0,clk_80, d_80, rst_80, q_80);
    end

endmodule
