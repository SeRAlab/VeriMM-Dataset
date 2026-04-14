`timescale 1ns/1ps

module fft_4point_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [7:0] x_imag_0;
    reg [7:0] x_imag_1;
    reg [7:0] x_imag_2;
    reg [7:0] x_imag_3;
    reg [7:0] x_real_0;
    reg [7:0] x_real_1;
    reg [7:0] x_real_2;
    reg [7:0] x_real_3;
    wire [7:0] y_imag_0;
    wire [7:0] y_imag_1;
    wire [7:0] y_imag_2;
    wire [7:0] y_imag_3;
    wire [7:0] y_real_0;
    wire [7:0] y_real_1;
    wire [7:0] y_real_2;
    wire [7:0] y_real_3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fft_4point dut (
        .clk(clk),
        .rst(rst),
        .x_imag_0(x_imag_0),
        .x_imag_1(x_imag_1),
        .x_imag_2(x_imag_2),
        .x_imag_3(x_imag_3),
        .x_real_0(x_real_0),
        .x_real_1(x_real_1),
        .x_real_2(x_real_2),
        .x_real_3(x_real_3),
        .y_imag_0(y_imag_0),
        .y_imag_1(y_imag_1),
        .y_imag_2(y_imag_2),
        .y_imag_3(y_imag_3),
        .y_real_0(y_real_0),
        .y_real_1(y_real_1),
        .y_real_2(y_real_2),
        .y_real_3(y_real_3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            x_imag_0 = 0; x_imag_1 = 0; x_imag_2 = 0; x_imag_3 = 0;
            x_real_0 = 0; x_real_1 = 0; x_real_2 = 0; x_real_3 = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test Case %0d: Unit Impulse", test_num);
            x_real_0 = 8'h01; x_real_1 = 8'h00; x_real_2 = 8'h00; x_real_3 = 8'h00;
            x_imag_0 = 8'h00; x_imag_1 = 8'h00; x_imag_2 = 8'h00; x_imag_3 = 8'h00;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h01, 8'h01, 8'h01, 8'h01);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test Case %0d: DC Signal", test_num);
            x_real_0 = 8'h01; x_real_1 = 8'h01; x_real_2 = 8'h01; x_real_3 = 8'h01;
            x_imag_0 = 8'h00; x_imag_1 = 8'h00; x_imag_2 = 8'h00; x_imag_3 = 8'h00;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h04, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test Case %0d: Complex Sinusoid", test_num);
            x_real_0 = 8'h01; x_real_1 = 8'h00; x_real_2 = 8'hFF; x_real_3 = 8'h00;
            x_imag_0 = 8'h00; x_imag_1 = 8'h01; x_imag_2 = 8'h00; x_imag_3 = 8'hFF;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h04, 8'h00, 8'h00);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test Case %0d: Alternating Signal", test_num);
            x_real_0 = 8'h01; x_real_1 = 8'hFF; x_real_2 = 8'h01; x_real_3 = 8'hFF;
            x_imag_0 = 8'h00; x_imag_1 = 8'h00; x_imag_2 = 8'h00; x_imag_3 = 8'h00;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h04, 8'h00);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test Case %0d: Arbitrary Signed Integers", test_num);
            x_real_0 = 8'h02; x_real_1 = 8'h03; x_real_2 = 8'h04; x_real_3 = 8'h05;
            x_imag_0 = 8'h00; x_imag_1 = 8'h00; x_imag_2 = 8'h00; x_imag_3 = 8'h00;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'h00, 8'h02, 8'h00, 8'hFE, 8'h0E, 8'hFE, 8'hFE, 8'hFE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fft_4point Testbench");
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
        input [7:0] expected_y_imag_0;
        input [7:0] expected_y_imag_1;
        input [7:0] expected_y_imag_2;
        input [7:0] expected_y_imag_3;
        input [7:0] expected_y_real_0;
        input [7:0] expected_y_real_1;
        input [7:0] expected_y_real_2;
        input [7:0] expected_y_real_3;
        begin
            if (expected_y_imag_0 === (expected_y_imag_0 ^ y_imag_0 ^ expected_y_imag_0) &&
                expected_y_imag_1 === (expected_y_imag_1 ^ y_imag_1 ^ expected_y_imag_1) &&
                expected_y_imag_2 === (expected_y_imag_2 ^ y_imag_2 ^ expected_y_imag_2) &&
                expected_y_imag_3 === (expected_y_imag_3 ^ y_imag_3 ^ expected_y_imag_3) &&
                expected_y_real_0 === (expected_y_real_0 ^ y_real_0 ^ expected_y_real_0) &&
                expected_y_real_1 === (expected_y_real_1 ^ y_real_1 ^ expected_y_real_1) &&
                expected_y_real_2 === (expected_y_real_2 ^ y_real_2 ^ expected_y_real_2) &&
                expected_y_real_3 === (expected_y_real_3 ^ y_real_3 ^ expected_y_real_3)) begin
                $display("PASS");
                $display("  Outputs: y_imag_0=%h, y_imag_1=%h, y_imag_2=%h, y_imag_3=%h, y_real_0=%h, y_real_1=%h, y_real_2=%h, y_real_3=%h",
                         y_imag_0, y_imag_1, y_imag_2, y_imag_3, y_real_0, y_real_1, y_real_2, y_real_3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y_imag_0=%h, y_imag_1=%h, y_imag_2=%h, y_imag_3=%h, y_real_0=%h, y_real_1=%h, y_real_2=%h, y_real_3=%h",
                         expected_y_imag_0, expected_y_imag_1, expected_y_imag_2, expected_y_imag_3, expected_y_real_0, expected_y_real_1, expected_y_real_2, expected_y_real_3);
                $display("  Got:      y_imag_0=%h, y_imag_1=%h, y_imag_2=%h, y_imag_3=%h, y_real_0=%h, y_real_1=%h, y_real_2=%h, y_real_3=%h",
                         y_imag_0, y_imag_1, y_imag_2, y_imag_3, y_real_0, y_real_1, y_real_2, y_real_3);
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
        $dumpvars(0,clk, rst, x_imag_0, x_imag_1, x_imag_2, x_imag_3, x_real_0, x_real_1, x_real_2, x_real_3, y_imag_0, y_imag_1, y_imag_2, y_imag_3, y_real_0, y_real_1, y_real_2, y_real_3);
    end

endmodule
