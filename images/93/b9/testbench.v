`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg mem_flush;
    reg [4:0] mem_gpr_wa;
    reg [31:0] mem_gpr_wd;
    reg mem_gpr_we;
    reg mem_stall;
    reg rst;
    reg wb_stall;
    wire [4:0] wb_gpr_wa;
    wire [31:0] wb_gpr_wd;
    wire wb_gpr_we;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .mem_flush(mem_flush),
        .mem_gpr_wa(mem_gpr_wa),
        .mem_gpr_wd(mem_gpr_wd),
        .mem_gpr_we(mem_gpr_we),
        .mem_stall(mem_stall),
        .rst(rst),
        .wb_stall(wb_stall),
        .wb_gpr_wa(wb_gpr_wa),
        .wb_gpr_wd(wb_gpr_wd),
        .wb_gpr_we(wb_gpr_we)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            mem_flush = 0;
            mem_gpr_wa = 0;
            mem_gpr_wd = 0;
            mem_gpr_we = 0;
            mem_stall = 0;
            wb_stall = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Normal Data Propagation");
            reset_dut();


            mem_gpr_wa = 5'd10;
            mem_gpr_wd = 32'hA5A5A5A5;
            mem_gpr_we = 1;

            @(posedge clk);
            #2;

            #1;


            check_outputs(5'd10, 32'hA5A5A5A5, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Reset behavior check");
            reset_dut();


            mem_gpr_wa = 5'd15;
            mem_gpr_wd = 32'hFFFFFFFF;
            mem_gpr_we = 1;
            rst = 1;

            @(posedge clk);
            #2;

            #1;


            check_outputs(5'd0, 32'h0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Flush behavior check");
            reset_dut();


            mem_gpr_wa = 5'd20;
            mem_gpr_wd = 32'h12345678;
            mem_gpr_we = 1;
            mem_flush = 1;

            @(posedge clk);
            #2;


            #1;



            check_outputs(5'd0, 32'h0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Stall behavior check");
            reset_dut();


            mem_gpr_wa = 5'd5;
            mem_gpr_wd = 32'hBEEFCAFE;
            mem_gpr_we = 1;
            @(posedge clk);
            #1;


            wb_stall = 1;
            mem_gpr_wa = 5'd31;
            mem_gpr_wd = 32'h0;
            mem_gpr_we = 0;

            @(posedge clk);
            #2;


            #1;



            check_outputs(5'd5, 32'hBEEFCAFE, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Stall release check");
            reset_dut();


            wb_stall = 1;
            mem_gpr_wa = 5'd8;
            mem_gpr_wd = 32'h88888888;
            mem_gpr_we = 1;
            @(posedge clk);
            #1;


            wb_stall = 0;
            @(posedge clk);
            #2;


            #1;



            check_outputs(5'd8, 32'h88888888, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Flush priority over Stall");
            reset_dut();


            mem_gpr_wa = 5'd1;
            mem_gpr_wd = 32'h11111111;
            mem_gpr_we = 1;
            @(posedge clk);
            #1;


            wb_stall = 1;
            mem_flush = 1;
            mem_gpr_wa = 5'd2;
            mem_gpr_wd = 32'h22222222;

            @(posedge clk);
            #2;


            #1;



            check_outputs(5'd0, 32'h0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Mem Stall check");
            reset_dut();


            mem_gpr_wa = 5'd4;
            mem_gpr_wd = 32'h44444444;
            mem_gpr_we = 1;
            @(posedge clk);
            #1;


            mem_stall = 1;
            mem_gpr_wa = 5'd9;
            mem_gpr_wd = 32'h99999999;

            @(posedge clk);
            #2;


            #1;



            check_outputs(5'd4, 32'h44444444, 1'b1);
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
        input [4:0] expected_wb_gpr_wa;
        input [31:0] expected_wb_gpr_wd;
        input expected_wb_gpr_we;
        begin
            if (expected_wb_gpr_wa === (expected_wb_gpr_wa ^ wb_gpr_wa ^ expected_wb_gpr_wa) &&
                expected_wb_gpr_wd === (expected_wb_gpr_wd ^ wb_gpr_wd ^ expected_wb_gpr_wd) &&
                expected_wb_gpr_we === (expected_wb_gpr_we ^ wb_gpr_we ^ expected_wb_gpr_we)) begin
                $display("PASS");
                $display("  Outputs: wb_gpr_wa=%h, wb_gpr_wd=%h, wb_gpr_we=%b",
                         wb_gpr_wa, wb_gpr_wd, wb_gpr_we);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: wb_gpr_wa=%h, wb_gpr_wd=%h, wb_gpr_we=%b",
                         expected_wb_gpr_wa, expected_wb_gpr_wd, expected_wb_gpr_we);
                $display("  Got:      wb_gpr_wa=%h, wb_gpr_wd=%h, wb_gpr_we=%b",
                         wb_gpr_wa, wb_gpr_wd, wb_gpr_we);
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
        $dumpvars(0,clk, mem_flush, mem_gpr_wa, mem_gpr_wd, mem_gpr_we, mem_stall, rst, wb_stall, wb_gpr_wa, wb_gpr_wd, wb_gpr_we);
    end

endmodule
