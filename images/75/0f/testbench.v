`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] api_addr;
    reg api_wr;
    reg [31:0] api_wr_data;
    reg clk;
    reg [6:0] internal_addr;
    wire [31:0] api_rd_data;
    wire [63:0] internal_rd_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .api_addr(api_addr),
        .api_wr(api_wr),
        .api_wr_data(api_wr_data),
        .clk(clk),
        .internal_addr(internal_addr),
        .api_rd_data(api_rd_data),
        .internal_rd_data(internal_rd_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            api_wr = 0;
            api_addr = 0;
            api_wr_data = 0;
            internal_addr = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: API Bank 0 Access");
            reset_dut();


            api_wr = 1;
            api_addr = 8'd20;
            api_wr_data = 32'hAAAA_BBBB;
            @(posedge clk);
            #1;


            api_wr = 0;
            api_addr = 8'd20;
            internal_addr = 7'd10;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'hAAAA_BBBB, {32'h0, 32'hAAAA_BBBB});
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: API Bank 1 Access");
            reset_dut();


            api_wr = 1;
            api_addr = 8'd11;
            api_wr_data = 32'h1234_5678;
            @(posedge clk);
            #1;


            api_wr = 0;
            api_addr = 8'd11;
            internal_addr = 7'd5;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h1234_5678, {32'h1234_5678, 32'h0});
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Internal Concatenation Check");
            reset_dut();



            api_wr = 1;
            api_addr = 8'd128;
            api_wr_data = 32'hCAFE_BABE;
            @(posedge clk);
            #1;

            api_addr = 8'd129;
            api_wr_data = 32'hDEAD_BEEF;
            @(posedge clk);
            #1;


            api_wr = 0;
            internal_addr = 7'd64;
            api_addr = 8'd128;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hCAFE_BABE, 64'hDEAD_BEEF_CAFE_BABE);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Boundary Index 127");
            reset_dut();


            api_wr = 1;
            api_addr = 8'd254;
            api_wr_data = 32'hFFFF_0000;
            @(posedge clk);
            #1;

            api_addr = 8'd255;
            api_wr_data = 32'h0000_FFFF;
            @(posedge clk);
            #1;

            api_wr = 0;
            internal_addr = 7'd127;
            api_addr = 8'd255;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0000_FFFF, 64'h0000_FFFF_FFFF_0000);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Overwriting and Bank Isolation");
            reset_dut();


            api_wr = 1;
            api_addr = 8'd0;
            api_wr_data = 32'h1111_1111;
            @(posedge clk);
            #1;

            api_wr_data = 32'h2222_2222;
            @(posedge clk);
            #1;

            api_addr = 8'd1;
            api_wr_data = 32'h3333_3333;
            @(posedge clk);
            #1;

            api_wr = 0;
            internal_addr = 7'd0;
            api_addr = 8'd0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h2222_2222, 64'h3333_3333_2222_2222);
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
        input [31:0] expected_api_rd_data;
        input [63:0] expected_internal_rd_data;
        begin
            if (expected_api_rd_data === (expected_api_rd_data ^ api_rd_data ^ expected_api_rd_data) &&
                expected_internal_rd_data === (expected_internal_rd_data ^ internal_rd_data ^ expected_internal_rd_data)) begin
                $display("PASS");
                $display("  Outputs: api_rd_data=%h, internal_rd_data=%h",
                         api_rd_data, internal_rd_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: api_rd_data=%h, internal_rd_data=%h",
                         expected_api_rd_data, expected_internal_rd_data);
                $display("  Got:      api_rd_data=%h, internal_rd_data=%h",
                         api_rd_data, internal_rd_data);
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
        $dumpvars(0,api_addr, api_wr, api_wr_data, clk, internal_addr, api_rd_data, internal_rd_data);
    end

endmodule
