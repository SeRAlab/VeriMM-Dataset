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
            repeat(4) @(posedge clk);
            #1;
            SH_EN = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Shifting in sequence 1011...", test_num);

            @(posedge clk); #1; SH_EN = 1; SER_IN = 1;
            @(posedge clk); #1; SH_EN = 1; SER_IN = 0;
            @(posedge clk); #1; SH_EN = 1; SER_IN = 1;
            @(posedge clk); #1; SH_EN = 1; SER_IN = 1;

            @(posedge clk); #1; SH_EN = 0;
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Testing SH_EN behavior...", test_num);

            @(posedge clk); #1; SH_EN = 1; SER_IN = 1;
            @(posedge clk); #1; SH_EN = 0; SER_IN = 0;
            @(posedge clk); #1; SH_EN = 1; SER_IN = 1;
            @(posedge clk); #1; SH_EN = 1; SER_IN = 0;
            @(posedge clk); #1; SH_EN = 1; SER_IN = 0;

            @(posedge clk); #1; SH_EN = 0;
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Testing MSB discard (5 shifts)...", test_num);

            @(posedge clk); #1; SH_EN = 1; SER_IN = 1;
            @(posedge clk); #1; SH_EN = 1; SER_IN = 0;
            @(posedge clk); #1; SH_EN = 1; SER_IN = 1;
            @(posedge clk); #1; SH_EN = 1; SER_IN = 0;
            @(posedge clk); #1; SH_EN = 1; SER_IN = 1;

            @(posedge clk); #1; SH_EN = 0;
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Shifting in all ones...", test_num);

            SH_EN = 1;
            SER_IN = 1;
            repeat(4) @(posedge clk);

            #1; SH_EN = 0;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying hold pattern when SH_EN=0...", test_num);


            @(posedge clk); #1; SH_EN = 1; SER_IN = 1;
            @(posedge clk); #1; SH_EN = 1; SER_IN = 0;
            @(posedge clk); #1; SH_EN = 1; SER_IN = 1;
            @(posedge clk); #1; SH_EN = 1; SER_IN = 0;


            #1; SH_EN = 0;
            repeat(5) begin
                SER_IN = ~SER_IN;
                @(posedge clk);
            end

            #1;
            #1;

            check_outputs(4'b1010);
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
