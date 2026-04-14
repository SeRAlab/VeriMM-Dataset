`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clk_en;
    reg hold;
    reg [98:0] request;
    reg reset;
    wire [98:0] arb_wait;
    wire [98:0] grant;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clk_en(clk_en),
        .hold(hold),
        .request(request),
        .reset(reset),
        .arb_wait(arb_wait),
        .grant(grant)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        clk_en = 0;
        hold = 0;
        request = 0;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();

        #1;


        check_outputs(99'h0, 99'h0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        clk_en = 1;
        request = 99'h1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(99'h0, 99'h1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        clk_en = 1;
        request = 99'hB;
        @(posedge clk);
        #1;

        #1;


        check_outputs(99'hA, 99'h1);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        clk_en = 1;
        request = 99'hA;
        @(posedge clk);
        #1;

        #1;


        check_outputs(99'h8, 99'h2);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        clk_en = 1;
        request = 99'h2;
        @(posedge clk);
        #1;

        hold = 1;
        request = 99'h3;
        @(posedge clk);
        #1;


        #1;



        check_outputs(99'h1, 99'h2);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        clk_en = 1;
        request = 99'h4;
        @(posedge clk);
        #1;

        clk_en = 0;
        request = 99'h1;
        @(posedge clk);
        #1;


        #1;



        check_outputs(99'h1, 99'h4);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        clk_en = 1;
        request = 99'h1;
        @(posedge clk);
        #1;

        request = 99'h2;
        @(posedge clk);
        #1;

        #1;


        check_outputs(99'h0, 99'h2);
    end
        endtask

    task testcase008;

    begin
        reset_dut();
        clk_en = 1;
        request = (99'h1 << 98) | (99'h1 << 50);
        @(posedge clk);
        #1;

        #1;


        check_outputs((99'h1 << 98), (99'h1 << 50));
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
        testcase008();
        
        
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
        input [98:0] expected_arb_wait;
        input [98:0] expected_grant;
        begin
            if (expected_arb_wait === (expected_arb_wait ^ arb_wait ^ expected_arb_wait) &&
                expected_grant === (expected_grant ^ grant ^ expected_grant)) begin
                $display("PASS");
                $display("  Outputs: arb_wait=%h, grant=%h",
                         arb_wait, grant);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: arb_wait=%h, grant=%h",
                         expected_arb_wait, expected_grant);
                $display("  Got:      arb_wait=%h, grant=%h",
                         arb_wait, grant);
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
        $dumpvars(0,clk, clk_en, hold, request, reset, arb_wait, grant);
    end

endmodule
