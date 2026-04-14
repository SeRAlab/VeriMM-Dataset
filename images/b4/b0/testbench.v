`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] d;
    reg load;
    reg reset;
    reg si;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .load(load),
        .reset(reset),
        .si(si),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            load = 0;
            d = 16'h0;
            si = 0;
            #12;
            reset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Async Reset", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Parallel Load 0xACE0", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            d = 16'hACE0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'hACE0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Shift Right with si=0", test_num);
            reset_dut();

            @(negedge clk);
            load = 1; d = 16'hFFFF;
            @(negedge clk);

            load = 0; si = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(16'h7FFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Shift Right with si=1", test_num);
            reset_dut();

            @(negedge clk);
            load = 1; d = 16'h0001;
            @(negedge clk);

            load = 0; si = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(16'h8000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: 4 consecutive shifts", test_num);
            reset_dut();

            @(negedge clk);
            load = 1; d = 16'h0000;
            @(negedge clk);
            load = 0; si = 1;
            repeat(4) @(posedge clk);
            #2;

            #1;


            check_outputs(16'hF000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Full 16-bit shift clear", test_num);
            reset_dut();

            @(negedge clk);
            load = 1; d = 16'hFFFF;
            @(negedge clk);
            load = 0; si = 0;
            repeat(16) @(posedge clk);
            #2;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Mix of Load and Shift", test_num);
            reset_dut();
            @(negedge clk);
            load = 1; d = 16'hAAAA;
            @(negedge clk);
            load = 0; si = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'hD555);
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
        input [15:0] expected_q;
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
        $dumpvars(0,clk, d, load, reset, si, q);
    end

endmodule
