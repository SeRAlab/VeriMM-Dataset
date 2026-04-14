`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [11:0] d;
    reg enable;
    reg set;
    wire [11:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .enable(enable),
        .set(set),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            set = 1;
            enable = 0;
            d = 12'h000;
            #15;
            set = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Asynchronous set check", test_num);
            reset_dut();
            set = 1;
            #1;
            #1;

            check_outputs(12'hFFF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Load data with enable=1", test_num);
            reset_dut();
            @(negedge clk);
            set = 0;
            enable = 1;
            d = 12'hA5A;
            @(posedge clk);
            #2;
            #1;

            check_outputs(12'hA5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Hold data with enable=0", test_num);
            reset_dut();

            @(negedge clk);
            enable = 1;
            d = 12'hABC;
            @(posedge clk);
            #2;

            @(negedge clk);
            enable = 0;
            d = 12'h123;
            @(posedge clk);
            #2;
            #1;

            check_outputs(12'hABC);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Priority check (Set > Enable)", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            d = 12'h123;
            set = 1;
            #2;
            #1;

            check_outputs(12'hFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Load zero value", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            d = 12'h000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Load FFF value", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            d = 12'hFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(12'hFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sequential toggle check", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1; d = 12'h111;
            @(posedge clk);
            #2;
            @(negedge clk);
            enable = 0; d = 12'h222;
            @(posedge clk);
            #2;
            @(negedge clk);
            enable = 1; d = 12'h333;
            @(posedge clk);
            #2;
            #1;

            check_outputs(12'h333);
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
        testcase007();
        
        
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
        input [11:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, d, enable, set, q);
    end

endmodule
