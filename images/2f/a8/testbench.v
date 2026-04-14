`timescale 1ns/1ps

module fft_4point_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in_imag0;
    reg [7:0] in_imag1;
    reg [7:0] in_imag2;
    reg [7:0] in_imag3;
    reg [7:0] in_real0;
    reg [7:0] in_real1;
    reg [7:0] in_real2;
    reg [7:0] in_real3;
    reg rst;
    wire done;
    wire [7:0] out_imag0;
    wire [7:0] out_imag1;
    wire [7:0] out_imag2;
    wire [7:0] out_imag3;
    wire [7:0] out_real0;
    wire [7:0] out_real1;
    wire [7:0] out_real2;
    wire [7:0] out_real3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fft_4point dut (
        .clk(clk),
        .in_imag0(in_imag0),
        .in_imag1(in_imag1),
        .in_imag2(in_imag2),
        .in_imag3(in_imag3),
        .in_real0(in_real0),
        .in_real1(in_real1),
        .in_real2(in_real2),
        .in_real3(in_real3),
        .rst(rst),
        .done(done),
        .out_imag0(out_imag0),
        .out_imag1(out_imag1),
        .out_imag2(out_imag2),
        .out_imag3(out_imag3),
        .out_real0(out_real0),
        .out_real1(out_real1),
        .out_real2(out_real2),
        .out_real3(out_real3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        in_real0 = 0; in_imag0 = 0;
        in_real1 = 0; in_imag1 = 0;
        in_real2 = 0; in_imag2 = 0;
        in_real3 = 0; in_imag3 = 0;
        @(posedge clk);
        #2 rst = 0;

        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        in_real0 = 8'h00; in_imag0 = 8'h00;
        in_real1 = 8'h00; in_imag1 = 8'h00;
        in_real2 = 8'h00; in_imag2 = 8'h00;
        in_real3 = 8'h00; in_imag3 = 8'h00;

        while (!done) @(posedge clk);
        #1;
        $display("Testcase %03d: All Zeros", test_num);
        #1;

        check_outputs(1'b1, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        in_real0 = 8'd10;  in_imag0 = 8'd0;
        in_real1 = 8'd0;   in_imag1 = 8'd0;
        in_real2 = 8'd0;   in_imag2 = 8'd0;
        in_real3 = 8'd0;   in_imag3 = 8'd0;

        while (!done) @(posedge clk);
        #1;
        $display("Testcase %03d: Impulse at x[0]", test_num);
        #1;

        check_outputs(1'b1, 8'h00, 8'h00, 8'h00, 8'h00, 8'h0a, 8'h0a, 8'h0a, 8'h0a);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        in_real0 = 8'd5; in_imag0 = 8'd0;
        in_real1 = 8'd5; in_imag1 = 8'd0;
        in_real2 = 8'd5; in_imag2 = 8'd0;
        in_real3 = 8'd5; in_imag3 = 8'd0;

        while (!done) @(posedge clk);
        #1;
        $display("Testcase %03d: DC Signal", test_num);
        #1;

        check_outputs(1'b1, 8'h00, 8'h00, 8'h00, 8'h00, 8'h14, 8'h00, 8'h00, 8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        in_real0 = 8'd10;  in_imag0 = 8'd0;
        in_real1 = -8'd10; in_imag1 = 8'd0;
        in_real2 = 8'd10;  in_imag2 = 8'd0;
        in_real3 = -8'd10; in_imag3 = 8'd0;

        while (!done) @(posedge clk);
        #1;
        $display("Testcase %03d: Alternating Real Signal", test_num);
        #1;

        check_outputs(1'b1, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h28, 8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        in_real0 = 8'd2;  in_imag0 = 8'd2;
        in_real1 = 8'd2;  in_imag1 = -8'd2;
        in_real2 = -8'd2; in_imag2 = -8'd2;
        in_real3 = -8'd2; in_imag3 = 8'd2;

        while (!done) @(posedge clk);
        #1;
        $display("Testcase %03d: Rotating Complex Signal", test_num);
        #1;

        check_outputs(1'b1, 8'h00, 8'h00, 8'h00, 8'h08, 8'h00, 8'h00, 8'h00, 8'h08);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        in_real0 = -8'd5; in_imag0 = 8'd0;
        in_real1 = -8'd5; in_imag1 = 8'd0;
        in_real2 = -8'd5; in_imag2 = 8'd0;
        in_real3 = -8'd5; in_imag3 = 8'd0;

        while (!done) @(posedge clk);
        #1;
        $display("Testcase %03d: Negative DC Signal", test_num);
        #1;

        check_outputs(1'b1, 8'h00, 8'h00, 8'h00, 8'h00, 8'hec, 8'h00, 8'h00, 8'h00);
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
        input expected_done;
        input [7:0] expected_out_imag0;
        input [7:0] expected_out_imag1;
        input [7:0] expected_out_imag2;
        input [7:0] expected_out_imag3;
        input [7:0] expected_out_real0;
        input [7:0] expected_out_real1;
        input [7:0] expected_out_real2;
        input [7:0] expected_out_real3;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_out_imag0 === (expected_out_imag0 ^ out_imag0 ^ expected_out_imag0) &&
                expected_out_imag1 === (expected_out_imag1 ^ out_imag1 ^ expected_out_imag1) &&
                expected_out_imag2 === (expected_out_imag2 ^ out_imag2 ^ expected_out_imag2) &&
                expected_out_imag3 === (expected_out_imag3 ^ out_imag3 ^ expected_out_imag3) &&
                expected_out_real0 === (expected_out_real0 ^ out_real0 ^ expected_out_real0) &&
                expected_out_real1 === (expected_out_real1 ^ out_real1 ^ expected_out_real1) &&
                expected_out_real2 === (expected_out_real2 ^ out_real2 ^ expected_out_real2) &&
                expected_out_real3 === (expected_out_real3 ^ out_real3 ^ expected_out_real3)) begin
                $display("PASS");
                $display("  Outputs: done=%b, out_imag0=%h, out_imag1=%h, out_imag2=%h, out_imag3=%h, out_real0=%h, out_real1=%h, out_real2=%h, out_real3=%h",
                         done, out_imag0, out_imag1, out_imag2, out_imag3, out_real0, out_real1, out_real2, out_real3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, out_imag0=%h, out_imag1=%h, out_imag2=%h, out_imag3=%h, out_real0=%h, out_real1=%h, out_real2=%h, out_real3=%h",
                         expected_done, expected_out_imag0, expected_out_imag1, expected_out_imag2, expected_out_imag3, expected_out_real0, expected_out_real1, expected_out_real2, expected_out_real3);
                $display("  Got:      done=%b, out_imag0=%h, out_imag1=%h, out_imag2=%h, out_imag3=%h, out_real0=%h, out_real1=%h, out_real2=%h, out_real3=%h",
                         done, out_imag0, out_imag1, out_imag2, out_imag3, out_real0, out_real1, out_real2, out_real3);
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
        $dumpvars(0,clk, in_imag0, in_imag1, in_imag2, in_imag3, in_real0, in_real1, in_real2, in_real3, rst, done, out_imag0, out_imag1, out_imag2, out_imag3, out_real0, out_real1, out_real2, out_real3);
    end

endmodule
