`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [17:0] d_in;
    reg strobe;
    wire [17:0] d_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d_in(d_in),
        .strobe(strobe),
        .d_out(d_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        strobe = 0;
        d_in = 18'h0;
        @(posedge clk);
        strobe = 1;
        d_in = 18'h0;
        @(posedge clk);
        strobe = 0;
        repeat(2) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Positive Ramp", test_num);
        reset_dut();


        d_in = 18'sd10;
        strobe = 1;
        @(posedge clk);
        strobe = 0;


        repeat(4) @(posedge clk);


        strobe = 1;
        d_in = 18'sd10;
        @(posedge clk);
        strobe = 0;


        @(posedge clk);
        #1;

        check_outputs(18'sd50);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Negative Ramp", test_num);
        reset_dut();


        d_in = -18'sd10;
        strobe = 1;
        @(posedge clk);
        strobe = 0;


        repeat(4) @(posedge clk);


        strobe = 1;
        d_in = -18'sd10;
        @(posedge clk);
        strobe = 0;

        @(posedge clk);
        #1;

        check_outputs(-18'sd50);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Slope Change", test_num);
        reset_dut();


        d_in = 18'sd20;
        strobe = 1;
        @(posedge clk);
        strobe = 0;
        repeat(4) @(posedge clk);


        strobe = 1;
        d_in = 18'sd10;
        @(posedge clk);
        strobe = 0;


        repeat(4) @(posedge clk);


        strobe = 1;
        d_in = 18'sd10;
        @(posedge clk);
        strobe = 0;

        @(posedge clk);
        #1;

        check_outputs(18'sd50);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero Crossing", test_num);
        reset_dut();


        d_in = 18'sd10;
        strobe = 1;
        @(posedge clk);
        strobe = 0;
        repeat(4) @(posedge clk);


        strobe = 1;
        d_in = -18'sd10;
        @(posedge clk);
        strobe = 0;


        repeat(4) @(posedge clk);


        strobe = 1;
        d_in = -18'sd10;
        @(posedge clk);
        strobe = 0;

        @(posedge clk);
        #1;

        check_outputs(-18'sd50);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Large Value", test_num);
        reset_dut();


        d_in = 18'sd1000;
        strobe = 1;
        @(posedge clk);
        strobe = 0;

        repeat(99) @(posedge clk);


        strobe = 1;
        d_in = 18'sd1000;
        @(posedge clk);
        strobe = 0;

        @(posedge clk);
        #1;

        check_outputs(18'sd100000);
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
        input [17:0] expected_d_out;
        begin
            if (expected_d_out === (expected_d_out ^ d_out ^ expected_d_out)) begin
                $display("PASS");
                $display("  Outputs: d_out=%h",
                         d_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d_out=%h",
                         expected_d_out);
                $display("  Got:      d_out=%h",
                         d_out);
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
        $dumpvars(0,clk, d_in, strobe, d_out);
    end

endmodule
