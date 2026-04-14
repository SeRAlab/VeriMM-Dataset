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
            tw = 36'h0;
            @(posedge clk);
            @(posedge clk);
            #1 jrst_n = 1;
            @(posedge clk);
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            tw = {18'h2AAAA, 18'h15555};
            repeat(10) @(posedge clkx2);
            #1;
            if (tr_clk == 1'b1)
                #1;

                check_outputs(1'b1, 18'h2AAAA);
            else
                #1;

                check_outputs(1'b0, 18'h15555);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            tw = {18'h3FFFF, 18'h00000};
            repeat(12) @(posedge clkx2);
            #1;
            if (tr_clk == 1'b1)
                #1;

                check_outputs(1'b1, 18'h3FFFF);
            else
                #1;

                check_outputs(1'b0, 18'h00000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            tw = {18'h00000, 18'h3FFFF};
            repeat(15) @(posedge clkx2);
            #1;
            if (tr_clk == 1'b1)
                #1;

                check_outputs(1'b1, 18'h00000);
            else
                #1;

                check_outputs(1'b0, 18'h3FFFF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            tw = {18'h12345, 18'h2A5A5};
            repeat(20) @(posedge clkx2);
            #1;
            if (tr_clk == 1'b1)
                #1;

                check_outputs(1'b1, 18'h12345);
            else
                #1;

                check_outputs(1'b0, 18'h2A5A5);
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
