`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] cyc_copy;
    reg toggle;
    wire toggle_up;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .cyc_copy(cyc_copy),
        .toggle(toggle),
        .toggle_up(toggle_up)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            toggle = 0;
            cyc_copy = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Transition 0 to 1", test_num);
            reset_dut();

            toggle = 1;
            cyc_copy = 8'h01;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Transition 1 to 0", test_num);
            reset_dut();


            toggle = 1;
            @(posedge clk);
            #1;


            toggle = 0;
            cyc_copy = 8'h02;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Check non-sampling between edges", test_num);
            reset_dut();

            toggle = 1;
            @(posedge clk);
            #1;


            #2 toggle = 0;
            #2 toggle = 1;
            #2 toggle = 0;
            #2 toggle = 1;

            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Multi-cycle stability", test_num);
            reset_dut();

            toggle = 1;
            cyc_copy = 8'hAA;
            @(posedge clk);
            #1;


            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Toggle every cycle", test_num);
            reset_dut();

            toggle = 1; @(posedge clk); #1;
            toggle = 0; @(posedge clk); #1;
            toggle = 1; @(posedge clk); #1;
            toggle = 0; @(posedge clk); #1;
            toggle = 1; @(posedge clk); #1;

            #1;


            check_outputs(1'b1);
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
        input expected_toggle_up;
        begin
            if (expected_toggle_up === (expected_toggle_up ^ toggle_up ^ expected_toggle_up)) begin
                $display("PASS");
                $display("  Outputs: toggle_up=%b",
                         toggle_up);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: toggle_up=%b",
                         expected_toggle_up);
                $display("  Got:      toggle_up=%b",
                         toggle_up);
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
        $dumpvars(0,clk, cyc_copy, toggle, toggle_up);
    end

endmodule
