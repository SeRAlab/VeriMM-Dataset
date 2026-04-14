`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg busy_in;
    reg clk_in;
    reg mem_stall;
    reg [31:0] mem_w_addr;
    reg [31:0] mem_w_data;
    reg mem_we;
    reg rdy_in;
    reg rst_in;
    wire [31:0] wb_w_addr;
    wire [31:0] wb_w_data;
    wire wb_we;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .busy_in(busy_in),
        .clk_in(clk_in),
        .mem_stall(mem_stall),
        .mem_w_addr(mem_w_addr),
        .mem_w_data(mem_w_data),
        .mem_we(mem_we),
        .rdy_in(rdy_in),
        .rst_in(rst_in),
        .wb_w_addr(wb_w_addr),
        .wb_w_data(wb_w_data),
        .wb_we(wb_we)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

        begin
            rst_in = 1;
            busy_in = 0;
            mem_stall = 0;
            mem_we = 0;
            mem_w_addr = 0;
            mem_w_data = 0;
            rdy_in = 0;
            @(posedge clk_in);
            #1;
            rst_in = 0;
            @(posedge clk_in);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset State Verification", test_num);
            reset_dut();


            #1;



            check_outputs(32'h0, 32'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Normal Write Operation", test_num);
            reset_dut();

            busy_in = 0;
            mem_stall = 0;
            rdy_in = 1;
            mem_we = 1;
            mem_w_addr = 32'hAAAA_BBBB;
            mem_w_data = 32'h1234_5678;

            @(posedge clk_in);
            #1;
            #1;

            check_outputs(32'hAAAA_BBBB, 32'h1234_5678, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Busy Input Blocking Write", test_num);
            reset_dut();

            busy_in = 1;
            mem_stall = 0;
            mem_we = 1;
            mem_w_addr = 32'hDEAD_BEEF;
            mem_w_data = 32'hCAFE_BABE;

            @(posedge clk_in);
            #1;

            #1;


            check_outputs(32'h0, 32'h0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Memory Stall Blocking Write", test_num);
            reset_dut();

            busy_in = 0;
            mem_stall = 1;
            mem_we = 1;
            mem_w_addr = 32'h5555_6666;
            mem_w_data = 32'h7777_8888;

            @(posedge clk_in);
            #1;

            #1;


            check_outputs(32'h0, 32'h0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Pass-through with Write Enable Low", test_num);
            reset_dut();

            busy_in = 0;
            mem_stall = 0;
            mem_we = 0;
            mem_w_addr = 32'h1111_2222;
            mem_w_data = 32'h3333_4444;

            @(posedge clk_in);
            #1;

            #1;


            check_outputs(32'h1111_2222, 32'h3333_4444, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Recovery from Stall", test_num);
            reset_dut();


            busy_in = 0;
            mem_stall = 1;
            mem_we = 1;
            mem_w_addr = 32'hA;
            mem_w_data = 32'hB;
            @(posedge clk_in);
            #1;


            mem_stall = 0;
            mem_w_addr = 32'hC;
            mem_w_data = 32'hD;
            @(posedge clk_in);
            #1;

            #1;


            check_outputs(32'hC, 32'hD, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Combined Busy and Stall", test_num);
            reset_dut();

            busy_in = 1;
            mem_stall = 1;
            mem_we = 1;
            mem_w_addr = 32'hFFFF_FFFF;
            mem_w_data = 32'hEEEE_EEEE;

            @(posedge clk_in);
            #1;
            #1;

            check_outputs(32'h0, 32'h0, 1'b0);
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
        input [31:0] expected_wb_w_addr;
        input [31:0] expected_wb_w_data;
        input expected_wb_we;
        begin
            if (expected_wb_w_addr === (expected_wb_w_addr ^ wb_w_addr ^ expected_wb_w_addr) &&
                expected_wb_w_data === (expected_wb_w_data ^ wb_w_data ^ expected_wb_w_data) &&
                expected_wb_we === (expected_wb_we ^ wb_we ^ expected_wb_we)) begin
                $display("PASS");
                $display("  Outputs: wb_w_addr=%h, wb_w_data=%h, wb_we=%b",
                         wb_w_addr, wb_w_data, wb_we);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: wb_w_addr=%h, wb_w_data=%h, wb_we=%b",
                         expected_wb_w_addr, expected_wb_w_data, expected_wb_we);
                $display("  Got:      wb_w_addr=%h, wb_w_data=%h, wb_we=%b",
                         wb_w_addr, wb_w_data, wb_we);
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
        $dumpvars(0,busy_in, clk_in, mem_stall, mem_w_addr, mem_w_data, mem_we, rdy_in, rst_in, wb_w_addr, wb_w_data, wb_we);
    end

endmodule
