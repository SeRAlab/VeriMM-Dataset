`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] bus;
    reg clk;
    reg ldb;
    wire [15:0] B;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bus(bus),
        .clk(clk),
        .ldb(ldb),
        .B(B)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ldb = 0;
            bus = 16'h0000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Load 0xAAAA", test_num);
            reset_dut();
            bus = 16'hAAAA;
            ldb = 1;
            @(posedge clk);
            #1;
            ldb = 0;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Hold value when ldb=0", test_num);
            reset_dut();

            bus = 16'h5555;
            ldb = 1;
            @(posedge clk);
            #1;

            bus = 16'hFFFF;
            ldb = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 0xFFFF", test_num);
            reset_dut();
            bus = 16'hFFFF;
            ldb = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 0x0000", test_num);
            reset_dut();

            bus = 16'h1234;
            ldb = 1;
            @(posedge clk);
            #1;

            bus = 16'h0000;
            ldb = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple transitions and hold", test_num);
            reset_dut();


            bus = 16'h1111;
            ldb = 1;
            @(posedge clk);
            #1;


            bus = 16'h2222;
            ldb = 0;
            @(posedge clk);
            #1;


            bus = 16'h3333;
            ldb = 1;
            @(posedge clk);
            #1;


            bus = 16'h4444;
            ldb = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h3333);
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
        input [15:0] expected_B;
        begin
            if (expected_B === (expected_B ^ B ^ expected_B)) begin
                $display("PASS");
                $display("  Outputs: B=%h",
                         B);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: B=%h",
                         expected_B);
                $display("  Got:      B=%h",
                         B);
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
        $dumpvars(0,bus, clk, ldb, B);
    end

endmodule
