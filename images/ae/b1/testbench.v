`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] MULTIPLICAND_HIGH;
    reg [7:0] MULTIPLICAND_LOW;
    reg clk;
    reg reset;
    wire [7:0] PRODUCT_HIGH;
    wire [7:0] PRODUCT_LOW;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .MULTIPLICAND_HIGH(MULTIPLICAND_HIGH),
        .MULTIPLICAND_LOW(MULTIPLICAND_LOW),
        .clk(clk),
        .reset(reset),
        .PRODUCT_HIGH(PRODUCT_HIGH),
        .PRODUCT_LOW(PRODUCT_LOW)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            MULTIPLICAND_LOW = 0;
            MULTIPLICAND_HIGH = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 0 * 0", test_num);
            reset_dut();
            MULTIPLICAND_LOW = 8'h00;
            MULTIPLICAND_HIGH = 8'h00;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 1 * 1", test_num);
            reset_dut();
            MULTIPLICAND_LOW = 8'h01;
            MULTIPLICAND_HIGH = 8'h01;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(8'h00, 8'h01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 255 * 0", test_num);
            reset_dut();
            MULTIPLICAND_LOW = 8'hFF;
            MULTIPLICAND_HIGH = 8'h00;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 255 * 1", test_num);
            reset_dut();
            MULTIPLICAND_LOW = 8'hFF;
            MULTIPLICAND_HIGH = 8'h01;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(8'h00, 8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 255 * 255", test_num);
            reset_dut();
            MULTIPLICAND_LOW = 8'hFF;
            MULTIPLICAND_HIGH = 8'hFF;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(8'hFE, 8'h01);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 128 * 2", test_num);
            reset_dut();
            MULTIPLICAND_LOW = 8'h80;
            MULTIPLICAND_HIGH = 8'h02;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(8'h01, 8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 15 * 15", test_num);
            reset_dut();
            MULTIPLICAND_LOW = 8'h0F;
            MULTIPLICAND_HIGH = 8'h0F;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(8'h00, 8'hE1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 171 * 205", test_num);
            reset_dut();
            MULTIPLICAND_LOW = 8'hAB;
            MULTIPLICAND_HIGH = 8'hCD;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(8'h88, 8'hEF);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 10 * 5", test_num);
            reset_dut();
            MULTIPLICAND_LOW = 8'd10;
            MULTIPLICAND_HIGH = 8'd5;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(8'h00, 8'h32);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 127 * 127", test_num);
            reset_dut();
            MULTIPLICAND_LOW = 8'h7F;
            MULTIPLICAND_HIGH = 8'h7F;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(8'h3F, 8'h01);
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
        input [7:0] expected_PRODUCT_HIGH;
        input [7:0] expected_PRODUCT_LOW;
        begin
            if (expected_PRODUCT_HIGH === (expected_PRODUCT_HIGH ^ PRODUCT_HIGH ^ expected_PRODUCT_HIGH) &&
                expected_PRODUCT_LOW === (expected_PRODUCT_LOW ^ PRODUCT_LOW ^ expected_PRODUCT_LOW)) begin
                $display("PASS");
                $display("  Outputs: PRODUCT_HIGH=%h, PRODUCT_LOW=%h",
                         PRODUCT_HIGH, PRODUCT_LOW);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PRODUCT_HIGH=%h, PRODUCT_LOW=%h",
                         expected_PRODUCT_HIGH, expected_PRODUCT_LOW);
                $display("  Got:      PRODUCT_HIGH=%h, PRODUCT_LOW=%h",
                         PRODUCT_HIGH, PRODUCT_LOW);
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
        $dumpvars(0,MULTIPLICAND_HIGH, MULTIPLICAND_LOW, clk, reset, PRODUCT_HIGH, PRODUCT_LOW);
    end

endmodule
