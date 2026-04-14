`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_a;
    reg [15:0] data_b;
    reg [1:0] decoder_out;
    reg reset;
    wire [31:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_a(data_a),
        .data_b(data_b),
        .decoder_out(decoder_out),
        .reset(reset),
        .product(product)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            data_a = 0;
            data_b = 0;
            decoder_out = 0;
            @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Decoder 2'b00 - Product should be 0", test_num);
            reset_dut();
            decoder_out = 2'b00;
            data_a = 16'd10;
            data_b = 16'd20;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Decoder 2'b01 - Product should be 0", test_num);
            reset_dut();
            decoder_out = 2'b01;
            data_a = 16'hFFFF;
            data_b = 16'hFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Decoder 2'b10 - 10 * 5", test_num);
            reset_dut();
            decoder_out = 2'b10;
            data_a = 16'd10;
            data_b = 16'd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd50);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Decoder 2'b11 - 1000 * 2000", test_num);
            reset_dut();
            decoder_out = 2'b11;
            data_a = 16'd1000;
            data_b = 16'd2000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd2000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Max Input Multiplication", test_num);
            reset_dut();
            decoder_out = 2'b10;
            data_a = 16'hFFFF;
            data_b = 16'hFFFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hFFFE0001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset behavior while inputs are active", test_num);
            reset_dut();
            decoder_out = 2'b11;
            data_a = 16'd100;
            data_b = 16'd100;
            @(posedge clk);
            #1;

            if (product !== 32'd10000) $display("Error: Initial product wrong");


            reset = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd0);
            reset = 0;
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Switching Decoder from Active to Inactive", test_num);
            reset_dut();
            decoder_out = 2'b10;
            data_a = 16'd25;
            data_b = 16'd4;
            @(posedge clk);
            #1;
            if (product !== 32'd100) $display("Error: Product should be 100");

            decoder_out = 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd0);
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
        input [31:0] expected_product;
        begin
            if (expected_product === (expected_product ^ product ^ expected_product)) begin
                $display("PASS");
                $display("  Outputs: product=%h",
                         product);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: product=%h",
                         expected_product);
                $display("  Got:      product=%h",
                         product);
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
        $dumpvars(0,clk, data_a, data_b, decoder_out, reset, product);
    end

endmodule
