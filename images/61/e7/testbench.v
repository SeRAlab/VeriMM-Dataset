`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] d;
    reg [4:0] dst;
    reg en;
    reg resetn;
    reg squashn;
    wire [31:0] q;
    wire stalled;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .dst(dst),
        .en(en),
        .resetn(resetn),
        .squashn(squashn),
        .q(q),
        .stalled(stalled)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            resetn = 0;
            en = 0;
            squashn = 1;
            d = 32'h0;
            dst = 5'h0;
            repeat(2) @(posedge clk);
            #1;
            resetn = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Post-Reset Initial State", test_num);
            reset_dut();

            #1;


            check_outputs(32'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Basic Data Propagation", test_num);
            reset_dut();
            d = 32'hABCDE123;
            dst = 5'h0A;
            en = 1;
            squashn = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hABCDE123, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Pipeline Hold (en=0)", test_num);
            reset_dut();

            d = 32'h11112222; en = 1;
            @(posedge clk);
            #1;

            d = 32'hFFFFFFFF; en = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h11112222, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Pipeline Squash", test_num);
            reset_dut();

            d = 32'hCAFEBABE; en = 1; squashn = 1;
            @(posedge clk);
            #1;

            squashn = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Combined Enable and Squash", test_num);
            reset_dut();
            d = 32'h5555AAAA; dst = 5'h1F; en = 1; squashn = 1;
            @(posedge clk);
            #1;

            d = 32'hDDDDDDDD; en = 0; squashn = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Continuous Data Stream", test_num);
            reset_dut();
            en = 1; squashn = 1;
            d = 32'h1; @(posedge clk); #1;
            d = 32'h2; @(posedge clk); #1;
            d = 32'h3; @(posedge clk); #1;
            #1;

            check_outputs(32'h3, 1'b0);
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
        input [31:0] expected_q;
        input expected_stalled;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_stalled === (expected_stalled ^ stalled ^ expected_stalled)) begin
                $display("PASS");
                $display("  Outputs: q=%h, stalled=%b",
                         q, stalled);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h, stalled=%b",
                         expected_q, expected_stalled);
                $display("  Got:      q=%h, stalled=%b",
                         q, stalled);
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
        $dumpvars(0,clk, d, dst, en, resetn, squashn, q, stalled);
    end

endmodule
