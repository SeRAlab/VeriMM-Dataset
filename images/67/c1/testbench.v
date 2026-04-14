`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] addr;
    reg ce;
    reg clk;
    reg [31:0] data_i;
    reg [3:0] sel;
    reg we;
    wire [31:0] check;
    wire [31:0] data_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .ce(ce),
        .clk(clk),
        .data_i(data_i),
        .sel(sel),
        .we(we),
        .check(check),
        .data_o(data_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr = 0;
            ce = 0;
            we = 0;
            data_i = 0;
            sel = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            ce = 0;
            addr = 8'hAA;
            sel = 4'hF;
            we = 0;
            @(posedge clk);
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            ce = 1;
            we = 1;
            addr = 8'h01;
            sel = 4'hF;
            data_i = 32'hAABBCCDD;
            @(posedge clk);

            #1;
            we = 0;
            @(posedge clk);
            #1;

            check_outputs(32'h0, 32'hAABBCCDD);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            ce = 1;
            we = 1;
            addr = 8'h00;
            sel = 4'hF;
            data_i = 32'h12345678;
            @(posedge clk);

            #1;
            we = 0;
            @(posedge clk);
            #1;

            check_outputs(32'h12345678, 32'h12345678);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            ce = 1;
            we = 1;
            addr = 8'h05;
            sel = 4'b0101;
            data_i = 32'h11223344;
            @(posedge clk);
            #1;

            we = 0;
            @(posedge clk);

            #1;


            check_outputs(32'h12345678, 32'h00220044);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            ce = 1;
            we = 0;
            addr = 8'h01;
            sel = 4'b1100;
            @(posedge clk);

            #1;


            check_outputs(32'h12345678, 32'hAABB0000);
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
        input [31:0] expected_check;
        input [31:0] expected_data_o;
        begin
            if (expected_check === (expected_check ^ check ^ expected_check) &&
                expected_data_o === (expected_data_o ^ data_o ^ expected_data_o)) begin
                $display("PASS");
                $display("  Outputs: check=%h, data_o=%h",
                         check, data_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: check=%h, data_o=%h",
                         expected_check, expected_data_o);
                $display("  Got:      check=%h, data_o=%h",
                         check, data_o);
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
        $dumpvars(0,addr, ce, clk, data_i, sel, we, check, data_o);
    end

endmodule
