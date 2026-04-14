`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] d;
    reg en;
    reg te;
    wire [31:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .en(en),
        .te(te),
        .q(q)
    );

        task reset_dut;

        begin
            d = 32'h0;
            en = 1'b0;
            te = 1'b0;
            @(negedge clk);


            en = 1'b1;
            te = 1'b1;
            d = 32'h0;
            @(negedge clk);
            en = 1'b0;
            te = 1'b0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            @(negedge clk);
            en = 1'b1;
            te = 1'b1;
            d = 32'hA5A5A5A5;
            @(negedge clk);
            #1;

            check_outputs(32'hA5A5A5A5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            en = 1'b1; te = 1'b1; d = 32'h11112222;
            @(negedge clk);

            en = 1'b0; te = 1'b1; d = 32'hFFFFFFFF;
            @(negedge clk);
            #1;

            check_outputs(32'h11112222);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            en = 1'b1; te = 1'b1; d = 32'hCAFECAFE;
            @(negedge clk);

            en = 1'b1; te = 1'b0; d = 32'h00000000;
            @(negedge clk);
            #1;

            check_outputs(32'hCAFECAFE);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            en = 1'b1; te = 1'b1; d = 32'h5555AAAA;
            @(negedge clk);

            en = 1'b0; te = 1'b0; d = 32'h12345678;
            @(negedge clk);
            #1;

            check_outputs(32'h5555AAAA);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            en = 1'b1;
            te = 1'b1;
            d = 32'h00000001;
            @(negedge clk);
            d = 32'h00000002;
            @(negedge clk);
            d = 32'hBCDEBCDE;
            @(negedge clk);
            #1;

            check_outputs(32'hBCDEBCDE);
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
        input [31:0] expected_q;
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
        $dumpvars(0,clk, d, en, te, q);
    end

endmodule
