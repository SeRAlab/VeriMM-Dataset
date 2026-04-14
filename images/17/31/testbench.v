`timescale 1ns/1ps

module matrix_factorization_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] matrix_in_00;
    reg [15:0] matrix_in_01;
    reg [15:0] matrix_in_10;
    reg [15:0] matrix_in_11;
    reg reset;
    wire [15:0] factor1_00;
    wire [15:0] factor1_01;
    wire [15:0] factor1_10;
    wire [15:0] factor1_11;
    wire [15:0] factor2_00;
    wire [15:0] factor2_01;
    wire [15:0] factor2_10;
    wire [15:0] factor2_11;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    matrix_factorization dut (
        .clk(clk),
        .matrix_in_00(matrix_in_00),
        .matrix_in_01(matrix_in_01),
        .matrix_in_10(matrix_in_10),
        .matrix_in_11(matrix_in_11),
        .reset(reset),
        .factor1_00(factor1_00),
        .factor1_01(factor1_01),
        .factor1_10(factor1_10),
        .factor1_11(factor1_11),
        .factor2_00(factor2_00),
        .factor2_01(factor2_01),
        .factor2_10(factor2_10),
        .factor2_11(factor2_11)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            matrix_in_00 = 0;
            matrix_in_01 = 0;
            matrix_in_10 = 0;
            matrix_in_11 = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %0d: Identity Matrix", test_num);
            matrix_in_00 = 16'h0001;
            matrix_in_01 = 16'h0000;
            matrix_in_10 = 16'h0000;
            matrix_in_11 = 16'h0001;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h0001, 16'h0000, 16'h0000, 16'h0001,
                          16'h0001, 16'h0000, 16'h0000, 16'h0001);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %0d: Scaled Identity", test_num);
            matrix_in_00 = 16'h0005;
            matrix_in_01 = 16'h0000;
            matrix_in_10 = 16'h0000;
            matrix_in_11 = 16'h0005;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h0001, 16'h0000, 16'h0000, 16'h0001,
                          16'h0005, 16'h0000, 16'h0000, 16'h0005);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase %0d: Basic LU Decomposition", test_num);
            matrix_in_00 = 16'd2;
            matrix_in_01 = 16'd4;
            matrix_in_10 = 16'd6;
            matrix_in_11 = 16'd20;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd1, 16'd0, 16'd3, 16'd1,
                          16'd2, 16'd4, 16'd0, 16'd8);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase %0d: Linearly Dependent Rows", test_num);
            matrix_in_00 = 16'd4;
            matrix_in_01 = 16'd8;
            matrix_in_10 = 16'd4;
            matrix_in_11 = 16'd8;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd1, 16'd0, 16'd1, 16'd1,
                          16'd4, 16'd8, 16'd0, 16'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase %0d: Larger Values", test_num);
            matrix_in_00 = 16'd10;
            matrix_in_01 = 16'd20;
            matrix_in_10 = 16'd30;
            matrix_in_11 = 16'd70;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd1, 16'd0, 16'd3, 16'd1,
                          16'd10, 16'd20, 16'd0, 16'd10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("matrix_factorization Testbench");
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
        input [15:0] expected_factor1_00;
        input [15:0] expected_factor1_01;
        input [15:0] expected_factor1_10;
        input [15:0] expected_factor1_11;
        input [15:0] expected_factor2_00;
        input [15:0] expected_factor2_01;
        input [15:0] expected_factor2_10;
        input [15:0] expected_factor2_11;
        begin
            if (expected_factor1_00 === (expected_factor1_00 ^ factor1_00 ^ expected_factor1_00) &&
                expected_factor1_01 === (expected_factor1_01 ^ factor1_01 ^ expected_factor1_01) &&
                expected_factor1_10 === (expected_factor1_10 ^ factor1_10 ^ expected_factor1_10) &&
                expected_factor1_11 === (expected_factor1_11 ^ factor1_11 ^ expected_factor1_11) &&
                expected_factor2_00 === (expected_factor2_00 ^ factor2_00 ^ expected_factor2_00) &&
                expected_factor2_01 === (expected_factor2_01 ^ factor2_01 ^ expected_factor2_01) &&
                expected_factor2_10 === (expected_factor2_10 ^ factor2_10 ^ expected_factor2_10) &&
                expected_factor2_11 === (expected_factor2_11 ^ factor2_11 ^ expected_factor2_11)) begin
                $display("PASS");
                $display("  Outputs: factor1_00=%h, factor1_01=%h, factor1_10=%h, factor1_11=%h, factor2_00=%h, factor2_01=%h, factor2_10=%h, factor2_11=%h",
                         factor1_00, factor1_01, factor1_10, factor1_11, factor2_00, factor2_01, factor2_10, factor2_11);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: factor1_00=%h, factor1_01=%h, factor1_10=%h, factor1_11=%h, factor2_00=%h, factor2_01=%h, factor2_10=%h, factor2_11=%h",
                         expected_factor1_00, expected_factor1_01, expected_factor1_10, expected_factor1_11, expected_factor2_00, expected_factor2_01, expected_factor2_10, expected_factor2_11);
                $display("  Got:      factor1_00=%h, factor1_01=%h, factor1_10=%h, factor1_11=%h, factor2_00=%h, factor2_01=%h, factor2_10=%h, factor2_11=%h",
                         factor1_00, factor1_01, factor1_10, factor1_11, factor2_00, factor2_01, factor2_10, factor2_11);
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
        $dumpvars(0,clk, matrix_in_00, matrix_in_01, matrix_in_10, matrix_in_11, reset, factor1_00, factor1_01, factor1_10, factor1_11, factor2_00, factor2_01, factor2_10, factor2_11);
    end

endmodule
