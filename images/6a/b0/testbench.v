`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] D;
    reg clk;
    reg load;
    reg rst;
    wire [31:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .clk(clk),
        .load(load),
        .rst(rst),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            load = 0;
            D = 0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Accumulation", test_num);
            reset_dut();

            D = 32'h0000_000A;
            load = 1;
            @(posedge clk);
            #1 load = 0;

            #1;


            check_outputs(32'h0000_000A);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sequential Accumulations", test_num);
            reset_dut();

            load = 1;
            D = 32'd100; @(posedge clk);
            D = 32'd200; @(posedge clk);
            D = 32'd300; @(posedge clk);
            #1 load = 0;

            #1;


            check_outputs(32'd600);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verify Load Enable/Hold", test_num);
            reset_dut();


            D = 32'h1234_5678;
            load = 1;
            @(posedge clk);


            #1 load = 0;
            D = 32'hFFFF_FFFF;
            @(posedge clk);
            @(posedge clk);

            #1;


            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Accumulator Overflow", test_num);
            reset_dut();

            load = 1;
            D = 32'hFFFF_FFFE;
            @(posedge clk);
            D = 32'h0000_0005;
            @(posedge clk);
            #1 load = 0;

            #1;


            check_outputs(32'h0000_0003);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset Priority over Load", test_num);
            reset_dut();


            load = 1;
            D = 32'hAAAA_BBBB;
            @(posedge clk);


            #1;
            rst = 1;
            load = 1;
            D = 32'h1111_2222;
            @(posedge clk);
            #1 rst = 0; load = 0;

            #1;


            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large Value Accumulation", test_num);
            reset_dut();

            load = 1;
            D = 32'h1000_0000;
            @(posedge clk);
            D = 32'h2000_0000;
            @(posedge clk);
            #1 load = 0;

            #1;


            check_outputs(32'h3000_0000);
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
        input [31:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,D, clk, load, rst, Q);
    end

endmodule
