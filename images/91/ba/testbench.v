`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg clk;
    reg go;
    reg [1:0] operation;
    reg reset;
    wire [31:0] difference;
    wire [31:0] product;
    wire [31:0] quotient;
    wire [31:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .go(go),
        .operation(operation),
        .reset(reset),
        .difference(difference),
        .product(product),
        .quotient(quotient),
        .sum(sum)
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
            go = 0;
            a = 0;
            b = 0;
            operation = 0;
            @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            a = 32'd50;
            b = 32'd25;
            operation = 2'b00;
            go = 1;
            @(posedge clk);
            go = 0;
            @(posedge clk);

            #1;


            check_outputs(32'd0, 32'd0, 32'd0, 32'd75);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            a = 32'd100;
            b = 32'd40;
            operation = 2'b01;
            go = 1;
            @(posedge clk);
            go = 0;
            @(posedge clk);
            #1;

            check_outputs(32'd60, 32'd0, 32'd0, 32'd0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            a = 32'd12;
            b = 32'd11;
            operation = 2'b10;
            go = 1;
            @(posedge clk);
            go = 0;
            @(posedge clk);
            #1;

            check_outputs(32'd0, 32'd132, 32'd0, 32'd0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            a = 32'd100;
            b = 32'd4;
            operation = 2'b11;
            go = 1;
            @(posedge clk);
            go = 0;
            @(posedge clk);
            #1;

            check_outputs(32'd0, 32'd0, 32'd25, 32'd0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            a = 32'd500;
            b = 32'd0;
            operation = 2'b11;
            go = 1;
            @(posedge clk);
            go = 0;
            @(posedge clk);

            #1;


            check_outputs(32'd0, 32'd0, 32'd0, 32'd0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            a = 32'd10;
            b = 32'd20;
            operation = 2'b01;
            go = 1;
            @(posedge clk);
            go = 0;
            @(posedge clk);
            #1;

            check_outputs(32'hFFFFFFF6, 32'd0, 32'd0, 32'd0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            a = 32'h0000FFFF;
            b = 32'h0000FFFF;
            operation = 2'b10;
            go = 1;
            @(posedge clk);
            go = 0;
            @(posedge clk);
            #1;

            check_outputs(32'd0, 32'hFFFE0001, 32'd0, 32'd0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();

            a = 32'd10; b = 32'd10; operation = 2'b00; go = 1;
            @(posedge clk); go = 0; @(posedge clk);

            reset = 1;
            @(posedge clk);
            reset = 0;
            @(posedge clk);
            #1;

            check_outputs(32'd0, 32'd0, 32'd0, 32'd0);
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
        input [31:0] expected_difference;
        input [31:0] expected_product;
        input [31:0] expected_quotient;
        input [31:0] expected_sum;
        begin
            if (expected_difference === (expected_difference ^ difference ^ expected_difference) &&
                expected_product === (expected_product ^ product ^ expected_product) &&
                expected_quotient === (expected_quotient ^ quotient ^ expected_quotient) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: difference=%h, product=%h, quotient=%h, sum=%h",
                         difference, product, quotient, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: difference=%h, product=%h, quotient=%h, sum=%h",
                         expected_difference, expected_product, expected_quotient, expected_sum);
                $display("  Got:      difference=%h, product=%h, quotient=%h, sum=%h",
                         difference, product, quotient, sum);
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
        $dumpvars(0,a, b, clk, go, operation, reset, difference, product, quotient, sum);
    end

endmodule
