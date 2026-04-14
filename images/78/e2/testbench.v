`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [10:0] addr_i;
    reg clk_i;
    reg [31:0] data_i;
    reg rst_i;
    reg wr_i;
    wire [31:0] data_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr_i(addr_i),
        .clk_i(clk_i),
        .data_i(data_i),
        .rst_i(rst_i),
        .wr_i(wr_i),
        .data_o(data_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            rst_i = 1;
            addr_i = 0;
            data_i = 0;
            wr_i = 0;
            repeat(2) @(posedge clk_i);
            #1 rst_i = 0;
            repeat(1) @(posedge clk_i);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Write and Read at Address 0");
            reset_dut();


            @(posedge clk_i);
            addr_i = 11'd0;
            data_i = 32'hDEADBEEF;
            wr_i = 1;


            @(posedge clk_i);
            wr_i = 0;

            @(posedge clk_i);
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Maximum Address Access (2047)");
            reset_dut();

            @(posedge clk_i);
            addr_i = 11'h7FF;
            data_i = 32'h12345678;
            wr_i = 1;

            @(posedge clk_i);
            wr_i = 0;

            @(posedge clk_i);
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Overwriting Data");
            reset_dut();


            @(posedge clk_i);
            addr_i = 11'd100;
            data_i = 32'hAAAA_AAAA;
            wr_i = 1;


            @(posedge clk_i);
            data_i = 32'hBBBB_BBBB;

            @(posedge clk_i);
            wr_i = 0;

            @(posedge clk_i);
            #1;

            check_outputs(32'hBBBB_BBBB);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Write-Enable (wr_i=0) Check");
            reset_dut();


            @(posedge clk_i);
            addr_i = 11'd50;
            data_i = 32'h5555_6666;
            wr_i = 1;
            @(posedge clk_i);


            wr_i = 0;
            data_i = 32'hFFFF_FFFF;
            @(posedge clk_i);


            addr_i = 11'd50;
            @(posedge clk_i);
            #1;

            check_outputs(32'h5555_6666);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Write-Through/Concurrent Update Check");
            reset_dut();

            @(posedge clk_i);
            addr_i = 11'd256;
            data_i = 32'hCAFE_CAFE;
            wr_i = 1;


            @(posedge clk_i);
            #1;
            #1;

            check_outputs(32'hCAFE_CAFE);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Multiple Address Stability");
            reset_dut();


            @(posedge clk_i);
            addr_i = 11'h10;
            data_i = 32'h1111_1111;
            wr_i = 1;


            @(posedge clk_i);
            addr_i = 11'h20;
            data_i = 32'h2222_2222;

            @(posedge clk_i);
            wr_i = 0;


            addr_i = 11'h10;
            @(posedge clk_i);
            #1;

            check_outputs(32'h1111_1111);
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
        input [31:0] expected_data_o;
        begin
            if (expected_data_o === (expected_data_o ^ data_o ^ expected_data_o)) begin
                $display("PASS");
                $display("  Outputs: data_o=%h",
                         data_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_o=%h",
                         expected_data_o);
                $display("  Got:      data_o=%h",
                         data_o);
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
        $dumpvars(0,addr_i, clk_i, data_i, rst_i, wr_i, data_o);
    end

endmodule
