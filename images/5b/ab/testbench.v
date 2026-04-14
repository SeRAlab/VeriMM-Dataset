`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg MEM_R_EN;
    reg MEM_W_EN;
    reg [31:0] addr;
    reg clk;
    reg rst;
    reg [31:0] wrData;
    wire [31:0] rdData;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .MEM_R_EN(MEM_R_EN),
        .MEM_W_EN(MEM_W_EN),
        .addr(addr),
        .clk(clk),
        .rst(rst),
        .wrData(wrData),
        .rdData(rdData)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            MEM_R_EN = 0;
            MEM_W_EN = 0;
            addr = 0;
            wrData = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            @(posedge clk);
            MEM_W_EN = 1;
            addr = 32'h0;
            wrData = 32'hDEADBEEF;
            @(posedge clk);
            MEM_W_EN = 0;

            MEM_R_EN = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            @(posedge clk);
            MEM_R_EN = 1;
            addr = 32'h0000_0064;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            @(posedge clk);
            MEM_W_EN = 1;
            addr = 32'd1020;
            wrData = 32'h12345678;
            @(posedge clk);
            MEM_W_EN = 0;
            MEM_R_EN = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            @(posedge clk);
            MEM_W_EN = 0;
            addr = 32'h0000_0010;
            wrData = 32'hFFFFFFFF;
            @(posedge clk);

            MEM_R_EN = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            @(posedge clk);
            MEM_W_EN = 1;
            addr = 32'h0000_0020;
            wrData = 32'hAAAA_AAAA;
            @(posedge clk);

            wrData = 32'h5555_5555;
            @(posedge clk);
            MEM_W_EN = 0;
            MEM_R_EN = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h5555_5555);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            @(posedge clk);
            MEM_W_EN = 1;
            addr = 32'd40;
            wrData = 32'hCAFE_BABE;
            @(posedge clk);

            MEM_W_EN = 1;
            MEM_R_EN = 1;
            addr = 32'd44;
            wrData = 32'h1122_3344;
            @(posedge clk);
            #1;



            MEM_W_EN = 0;
            MEM_R_EN = 1;
            addr = 32'd44;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h1122_3344);
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
        input [31:0] expected_rdData;
        begin
            if (expected_rdData === (expected_rdData ^ rdData ^ expected_rdData)) begin
                $display("PASS");
                $display("  Outputs: rdData=%h",
                         rdData);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rdData=%h",
                         expected_rdData);
                $display("  Got:      rdData=%h",
                         rdData);
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
        $dumpvars(0,MEM_R_EN, MEM_W_EN, addr, clk, rst, wrData, rdData);
    end

endmodule
