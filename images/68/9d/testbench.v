`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] bus_in;
    reg clk;
    reg cs_16_in;
    reg cs_16_out1;
    reg cs_16_out2;
    reg cs_h_in;
    reg cs_h_out1;
    reg cs_h_out2;
    reg cs_l_in;
    reg cs_l_out1;
    reg cs_l_out2;
    reg [1:0] num1;
    reg [1:0] num2;
    wire [15:0] bus_out1;
    wire [15:0] bus_out2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bus_in(bus_in),
        .clk(clk),
        .cs_16_in(cs_16_in),
        .cs_16_out1(cs_16_out1),
        .cs_16_out2(cs_16_out2),
        .cs_h_in(cs_h_in),
        .cs_h_out1(cs_h_out1),
        .cs_h_out2(cs_h_out2),
        .cs_l_in(cs_l_in),
        .cs_l_out1(cs_l_out1),
        .cs_l_out2(cs_l_out2),
        .num1(num1),
        .num2(num2),
        .bus_out1(bus_out1),
        .bus_out2(bus_out2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            bus_in = 0;
            cs_16_in = 0; cs_h_in = 0; cs_l_in = 0;
            cs_16_out1 = 0; cs_h_out1 = 0; cs_l_out1 = 0;
            cs_16_out2 = 0; cs_h_out2 = 0; cs_l_out2 = 0;
            num1 = 0; num2 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            num1 = 2'd0;
            bus_in = 16'hABCD;
            cs_16_in = 1;
            @(posedge clk);
            #1;
            cs_16_in = 0;

            cs_16_out1 = 1;
            #1;
            #1;

            check_outputs(16'hABCD, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            num1 = 2'd1;
            bus_in = 16'h5500;
            cs_h_in = 1;
            @(posedge clk);
            #1;
            cs_h_in = 0;

            bus_in = 16'h00AA;
            cs_l_in = 1;
            @(posedge clk);
            #1;
            cs_l_in = 0;

            num2 = 2'd1;
            cs_16_out2 = 1;
            #1;
            #1;

            check_outputs(16'h0000, 16'h55AA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            num1 = 2'd2;
            bus_in = 16'h1234;
            cs_16_in = 1;
            @(posedge clk);
            #1;
            cs_16_in = 0;

            num1 = 2'd2;
            num2 = 2'd2;
            cs_h_out1 = 1;
            cs_l_out2 = 1;
            #1;
            #1;

            check_outputs(16'h1200, 16'h0034);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            num1 = 2'd0; bus_in = 16'hAAAA; cs_16_in = 1;
            @(posedge clk); #1;

            num1 = 2'd3; bus_in = 16'hBBBB; cs_16_in = 1;
            @(posedge clk); #1;
            cs_16_in = 0;

            num1 = 2'd0;
            num2 = 2'd3;
            cs_16_out1 = 1;
            cs_16_out2 = 1;
            #1;
            #1;

            check_outputs(16'hAAAA, 16'hBBBB);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            num1 = 2'd1;
            bus_in = 16'hFFFF;
            cs_16_in = 1;
            @(posedge clk); #1;

            bus_in = 16'h00FF;
            cs_16_in = 0;
            cs_h_in = 1;
            @(posedge clk); #1;
            cs_h_in = 0;

            num1 = 2'd1;
            cs_16_out1 = 1;
            #1;
            #1;

            check_outputs(16'h00FF, 16'h0000);
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
        input [15:0] expected_bus_out1;
        input [15:0] expected_bus_out2;
        begin
            if (expected_bus_out1 === (expected_bus_out1 ^ bus_out1 ^ expected_bus_out1) &&
                expected_bus_out2 === (expected_bus_out2 ^ bus_out2 ^ expected_bus_out2)) begin
                $display("PASS");
                $display("  Outputs: bus_out1=%h, bus_out2=%h",
                         bus_out1, bus_out2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bus_out1=%h, bus_out2=%h",
                         expected_bus_out1, expected_bus_out2);
                $display("  Got:      bus_out1=%h, bus_out2=%h",
                         bus_out1, bus_out2);
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
        $dumpvars(0,bus_in, clk, cs_16_in, cs_16_out1, cs_16_out2, cs_h_in, cs_h_out1, cs_h_out2, cs_l_in, cs_l_out1, cs_l_out2, num1, num2, bus_out1, bus_out2);
    end

endmodule
