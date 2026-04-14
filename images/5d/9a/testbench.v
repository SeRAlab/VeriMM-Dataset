`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clkx2;
    reg jrst_n;
    reg [35:0] tw;
    wire tr_clk;
    wire [17:0] tr_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clkx2(clkx2),
        .jrst_n(jrst_n),
        .tw(tw),
        .tr_clk(tr_clk),
        .tr_data(tr_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            jrst_n = 0;
            tw = 0;
            #12;
            jrst_n = 1;
            repeat(4) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            tw = 36'h000000000;
            repeat(5) @(posedge clk);
            #1;
            if (tr_clk)
                #1;

                check_outputs(1'b1, tw[17:0]);
            else
                #1;

                check_outputs(1'b0, tw[35:18]);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            tw = 36'hFFFFFFFFF;
            repeat(5) @(posedge clk);
            #1;
            if (tr_clk)
                #1;

                check_outputs(1'b1, tw[17:0]);
            else
                #1;

                check_outputs(1'b0, tw[35:18]);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            tw = 36'h00000AAAAA;
            repeat(8) @(posedge clk);
            #1;
            if (tr_clk)
                #1;

                check_outputs(1'b1, tw[17:0]);
            else
                #1;

                check_outputs(1'b0, tw[35:18]);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            tw = 36'h5555500000;
            repeat(8) @(posedge clk);
            #1;
            if (tr_clk)
                #1;

                check_outputs(1'b1, tw[17:0]);
            else
                #1;

                check_outputs(1'b0, tw[35:18]);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            tw = 36'hA5A5A5A5A;
            repeat(10) @(posedge clk);
            #1;
            if (tr_clk)
                #1;

                check_outputs(1'b1, tw[17:0]);
            else
                #1;

                check_outputs(1'b0, tw[35:18]);
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
        input expected_tr_clk;
        input [17:0] expected_tr_data;
        begin
            if (expected_tr_clk === (expected_tr_clk ^ tr_clk ^ expected_tr_clk) &&
                expected_tr_data === (expected_tr_data ^ tr_data ^ expected_tr_data)) begin
                $display("PASS");
                $display("  Outputs: tr_clk=%b, tr_data=%h",
                         tr_clk, tr_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tr_clk=%b, tr_data=%h",
                         expected_tr_clk, expected_tr_data);
                $display("  Got:      tr_clk=%b, tr_data=%h",
                         tr_clk, tr_data);
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
        $dumpvars(0,clk, clkx2, jrst_n, tw, tr_clk, tr_data);
    end

endmodule
