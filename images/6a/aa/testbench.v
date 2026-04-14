`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in1;
    reg [15:0] data_in2;
    reg enable_pipeline;
    reg reset;
    wire [31:0] product_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in1(data_in1),
        .data_in2(data_in2),
        .enable_pipeline(enable_pipeline),
        .reset(reset),
        .product_out(product_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in1 = 0;
            data_in2 = 0;
            enable_pipeline = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Direct Multi (0 x 0)");
            reset_dut();
            enable_pipeline = 0;
            data_in1 = 16'h0000;
            data_in2 = 16'h0000;
            @(posedge clk);
            #1 #1;
 check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Direct Multi (FFFF x FFFF)");
            reset_dut();
            enable_pipeline = 0;
            data_in1 = 16'hFFFF;
            data_in2 = 16'hFFFF;
            @(posedge clk);
            #1 #1;
 check_outputs(32'hFFFE0001);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Direct Multi (1234 x 5678)");
            reset_dut();
            enable_pipeline = 0;
            data_in1 = 16'd1234;
            data_in2 = 16'd5678;
            @(posedge clk);
            #1 #1;
 check_outputs(32'd7006652);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Running testcase004: Pipelined Multi (100 x 200)");
            reset_dut();
            enable_pipeline = 1;
            data_in1 = 16'd100;
            data_in2 = 16'd200;

            for(i=0; i<8; i=i+1) @(posedge clk);
            #1 #1;
 check_outputs(32'd20000);
        end
        endtask

    task testcase005;

        integer i;
        begin
            $display("Running testcase005: Pipelined Multi (8000 x 4000)");
            reset_dut();
            enable_pipeline = 1;
            data_in1 = 16'h8000;
            data_in2 = 16'h4000;
            for(i=0; i<8; i=i+1) @(posedge clk);
            #1 #1;
 check_outputs(32'h20000000);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Reset mid-operation");
            reset_dut();
            enable_pipeline = 0;
            data_in1 = 16'hA5A5;
            data_in2 = 16'h5A5A;
            @(posedge clk);
            reset = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(32'h0);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Direct Multi (ABCD x 0)");
            reset_dut();
            enable_pipeline = 0;
            data_in1 = 16'hABCD;
            data_in2 = 16'h0000;
            @(posedge clk);
            #1 #1;
 check_outputs(32'h00000000);
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
        input [31:0] expected_product_out;
        begin
            if (expected_product_out === (expected_product_out ^ product_out ^ expected_product_out)) begin
                $display("PASS");
                $display("  Outputs: product_out=%h",
                         product_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: product_out=%h",
                         expected_product_out);
                $display("  Got:      product_out=%h",
                         product_out);
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
        $dumpvars(0,clk, data_in1, data_in2, enable_pipeline, reset, product_out);
    end

endmodule
