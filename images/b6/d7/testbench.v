`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg SER_IN;
    reg SH_EN;
    reg clk;
    wire [3:0] PAR_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .SER_IN(SER_IN),
        .SH_EN(SH_EN),
        .clk(clk),
        .PAR_OUT(PAR_OUT)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            SER_IN = 0;
            SH_EN = 1;
            repeat(4) @(negedge clk);
            SH_EN = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shifting in 1011", test_num);
            reset_dut();

            @(negedge clk);
            SH_EN = 1; SER_IN = 1;
            @(negedge clk);
            SH_EN = 1; SER_IN = 0;
            @(negedge clk);
            SH_EN = 1; SER_IN = 1;
            @(negedge clk);
            SH_EN = 1; SER_IN = 1;
            @(negedge clk);
            SH_EN = 0;




            #1;





            check_outputs(4'b1101);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shifting in 1111", test_num);
            reset_dut();

            @(negedge clk);
            SH_EN = 1; SER_IN = 1;
            repeat(3) @(negedge clk);
            SH_EN = 0;

            #1;


            check_outputs(4'b1111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify SH_EN inhibits shifting", test_num);
            reset_dut();

            @(negedge clk);
            SH_EN = 1; SER_IN = 1;
            @(negedge clk);
            SH_EN = 0; SER_IN = 0;
            @(negedge clk);
            SH_EN = 0; SER_IN = 1;
            @(negedge clk);
            SH_EN = 1; SER_IN = 1;
            @(negedge clk);
            SH_EN = 1; SER_IN = 0;
            @(negedge clk);
            SH_EN = 1; SER_IN = 0;
            @(negedge clk);
            SH_EN = 0;

            #1;


            check_outputs(4'b0011);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Over-shifting 5 bits (11110)", test_num);
            reset_dut();

            @(negedge clk);
            SH_EN = 1; SER_IN = 1;
            repeat(4) @(negedge clk);
            SER_IN = 0; @(negedge clk);
            SH_EN = 0;


            #1;



            check_outputs(4'b0111);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits 1010", test_num);
            reset_dut();

            @(negedge clk);
            SH_EN = 1; SER_IN = 1; @(negedge clk);
            SH_EN = 1; SER_IN = 0; @(negedge clk);
            SH_EN = 1; SER_IN = 1; @(negedge clk);
            SH_EN = 1; SER_IN = 0; @(negedge clk);
            SH_EN = 0;

            #1;


            check_outputs(4'b0101);
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
        input [3:0] expected_PAR_OUT;
        begin
            if (expected_PAR_OUT === (expected_PAR_OUT ^ PAR_OUT ^ expected_PAR_OUT)) begin
                $display("PASS");
                $display("  Outputs: PAR_OUT=%h",
                         PAR_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PAR_OUT=%h",
                         expected_PAR_OUT);
                $display("  Got:      PAR_OUT=%h",
                         PAR_OUT);
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
        $dumpvars(0,SER_IN, SH_EN, clk, PAR_OUT);
    end

endmodule
