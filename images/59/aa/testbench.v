`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] in;
    reg reset;
    wire [31:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .reset(reset),
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
            in = 0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Accumulation", test_num);
            reset_dut();

            @(posedge clk);
            in = 32'd10;
            @(posedge clk);
            in = 32'd20;
            @(posedge clk);
            in = 32'd30;
            @(posedge clk);


            #1;



            check_outputs(32'd60);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Overflow Wrap-around", test_num);
            reset_dut();

            @(posedge clk);
            in = 32'hFFFFFFFF;
            @(posedge clk);
            in = 32'h00000001;
            @(posedge clk);


            #1;



            check_outputs(32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Large Number Addition", test_num);
            reset_dut();

            @(posedge clk);
            in = 32'h12345678;
            @(posedge clk);
            in = 32'h87654321;
            @(posedge clk);

            #1;


            check_outputs(32'h99999999);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("Testcase %0d: Sustained Input (Counter)", test_num);
            reset_dut();

            in = 32'd1;
            for (i = 0; i < 10; i = i + 1) begin
                @(posedge clk);
            end

            #1;


            check_outputs(32'd10);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Zero Accumulation", test_num);
            reset_dut();

            @(posedge clk);
            in = 32'hABCDEFFF;
            @(posedge clk);
            in = 32'd0;
            @(posedge clk);
            in = 32'd0;
            @(posedge clk);

            #1;


            check_outputs(32'hABCDEFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Max Value Wrap-around", test_num);
            reset_dut();

            @(posedge clk);
            in = 32'hFFFFFFFF;
            @(posedge clk);
            in = 32'hFFFFFFFF;
            @(posedge clk);

            #1;


            check_outputs(32'hFFFFFFFE);
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
        $dumpvars(0,clk, in, reset, q);
    end

endmodule
