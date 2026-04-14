`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg clk;
    wire [7:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .product(product)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        A <= 0;
        B <= 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        reset_dut();
        A <= 8'd25;
        B <= 8'd0;
        @(posedge clk);
        #1;
        $display("Test %0d: 25 * 0", test_num);
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        reset_dut();
        A <= 8'd1;
        B <= 8'd42;
        @(posedge clk);
        #1;
        $display("Test %0d: 1 * 42", test_num);
        #1;

        check_outputs(8'd42);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        reset_dut();
        A <= 8'd12;
        B <= 8'd5;
        @(posedge clk);
        #1;
        $display("Test %0d: 12 * 5", test_num);
        #1;

        check_outputs(8'd60);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        reset_dut();
        A <= 8'd15;
        B <= 8'd10;
        @(posedge clk);
        #1;
        $display("Test %0d: 15 * 10", test_num);
        #1;

        check_outputs(8'd150);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        reset_dut();
        A <= 8'd128;
        B <= 8'd2;
        @(posedge clk);
        #1;
        $display("Test %0d: 128 * 2 (Overflow check)", test_num);
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        reset_dut();
        A <= 8'd255;
        B <= 8'd1;
        @(posedge clk);
        #1;
        $display("Test %0d: 255 * 1", test_num);
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        reset_dut();
        A <= 8'd255;
        B <= 8'd255;
        @(posedge clk);
        #1;
        $display("Test %0d: 255 * 255 (Truncated result)", test_num);

        #1;


        check_outputs(8'h01);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        reset_dut();
        A <= 8'd7;
        B <= 8'd9;
        @(posedge clk);
        #1;
        $display("Test %0d: 7 * 9", test_num);
        #1;

        check_outputs(8'd63);
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
        input [7:0] expected_product;
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
        $dumpvars(0,A, B, clk, product);
    end

endmodule
