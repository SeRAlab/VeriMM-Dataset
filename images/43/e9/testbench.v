`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg cchld;
    reg clk;
    reg enable;
    reg [15:0] incoming_data;
    reg loopen;
    reg pcen;
    reg reset;
    reg [15:0] rn;
    wire [15:0] pc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cchld(cchld),
        .clk(clk),
        .enable(enable),
        .incoming_data(incoming_data),
        .loopen(loopen),
        .pcen(pcen),
        .reset(reset),
        .rn(rn),
        .pc(pc)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            cchld = 0;
            pcen = 0;
            loopen = 0;
            enable = 0;
            rn = 16'h0000;
            incoming_data = 16'h0000;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            enable = 1;
            incoming_data = 16'hABCD;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            loopen = 1;
            rn = 16'h55AA;
            #1;

            check_outputs(16'h55AA);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            pcen = 1;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            enable = 1;
            loopen = 1;
            incoming_data = 16'h1111;
            rn = 16'h2222;
            #1;

            check_outputs(16'h1111);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            loopen = 1;
            pcen = 1;
            rn = 16'h3333;
            #1;

            check_outputs(16'h3333);
        end
        endtask

    task testcase007;

        begin
            reset_dut();

            enable = 1;
            incoming_data = 16'h4444;
            @(posedge clk);
            #1;
            enable = 0;

            cchld = 1;
            pcen = 1;
            #1;

            check_outputs(16'h4444);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            pcen = 1;
            @(posedge clk); #1;
            @(posedge clk); #1;
            #1;

            check_outputs(16'h0003);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            enable = 1;
            incoming_data = 16'hFFFF;
            @(posedge clk);
            #1;
            enable = 0;
            pcen = 1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            enable = 1;
            incoming_data = 16'h7777;
            reset = 1;
            #1;

            check_outputs(16'h0000);
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
        testcase009();
        testcase010();
        
        
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
        input [15:0] expected_pc;
        begin
            if (expected_pc === (expected_pc ^ pc ^ expected_pc)) begin
                $display("PASS");
                $display("  Outputs: pc=%h",
                         pc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pc=%h",
                         expected_pc);
                $display("  Got:      pc=%h",
                         pc);
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
        $dumpvars(0,cchld, clk, enable, incoming_data, loopen, pcen, reset, rn, pc);
    end

endmodule
