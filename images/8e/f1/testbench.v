`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] pm;
    wire [63:0] rndout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .pm(pm),
        .rndout(rndout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        pm = 64'd0;
        @(negedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All Zeros", test_num);
        reset_dut();
        pm = 64'h0000000000000000;
        @(posedge clk);
        #2;
        #1;

        check_outputs(64'h0000000000000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All Ones", test_num);
        reset_dut();
        pm = 64'hFFFFFFFFFFFFFFFF;
        @(posedge clk);
        #2;
        #1;

        check_outputs(64'hFFFFFFFFFFFFFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Alternating pattern 0xAAAA...", test_num);
        reset_dut();
        pm = 64'hAAAAAAAAAAAAAAAA;
        @(posedge clk);
        #2;
        #1;

        check_outputs(64'hAAAAAAAAAAAAAAAA);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Alternating pattern 0x5555...", test_num);
        reset_dut();
        pm = 64'h5555555555555555;
        @(posedge clk);
        #2;
        #1;

        check_outputs(64'h5555555555555555);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Random Hex Pattern", test_num);
        reset_dut();
        pm = 64'hDEADBEEFCAFEBABE;
        @(posedge clk);
        #2;
        #1;

        check_outputs(64'hDEADBEEFCAFEBABE);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Walking One Pattern", test_num);
        reset_dut();
        pm = 64'h0000000000000001 << 32;
        @(posedge clk);
        #2;
        #1;

        check_outputs(64'h0000000100000000);
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
        input [63:0] expected_rndout;
        begin
            if (expected_rndout === (expected_rndout ^ rndout ^ expected_rndout)) begin
                $display("PASS");
                $display("  Outputs: rndout=%h",
                         rndout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rndout=%h",
                         expected_rndout);
                $display("  Got:      rndout=%h",
                         rndout);
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
        $dumpvars(0,clk, pm, rndout);
    end

endmodule
