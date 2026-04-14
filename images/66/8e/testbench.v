`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [7:0] pdata;
    reg sdata;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .load(load),
        .pdata(pdata),
        .sdata(sdata),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            load = 1;
            pdata = 8'h00;
            sdata = 0;
            @(posedge clk);
            #1;
            load = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Synchronous Parallel Load");
            reset_dut();
            test_num = 1;
            load = 1;
            pdata = 8'hA5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Single Right Shift");
            reset_dut();
            test_num = 2;

            load = 1; pdata = 8'h01; @(posedge clk); #1;

            load = 0; sdata = 1; @(posedge clk); #1;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Multiple Shifts Sequence (1, 0, 1, 1)");
            reset_dut();
            test_num = 3;

            load = 1; pdata = 8'h00; @(posedge clk); #1;

            load = 0; sdata = 1; @(posedge clk); #1;
            load = 0; sdata = 0; @(posedge clk); #1;
            load = 0; sdata = 1; @(posedge clk); #1;
            load = 0; sdata = 1; @(posedge clk); #1;
            #1;

            check_outputs(8'hD0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Clear register with 8 shifts");
            reset_dut();
            test_num = 4;

            load = 1; pdata = 8'hFF; @(posedge clk); #1;

            load = 0; sdata = 0;
            repeat(8) begin
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Parallel Load Priority");
            reset_dut();
            test_num = 5;

            load = 1;
            pdata = 8'h3C;
            sdata = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h3C);
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
        input [7:0] expected_q;
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
        $dumpvars(0,clk, load, pdata, sdata, q);
    end

endmodule
