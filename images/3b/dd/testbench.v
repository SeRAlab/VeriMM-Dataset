`timescale 1ns/1ps

module fft_4point_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] imag_in0;
    reg [7:0] imag_in1;
    reg [7:0] imag_in2;
    reg [7:0] imag_in3;
    reg [7:0] real_in0;
    reg [7:0] real_in1;
    reg [7:0] real_in2;
    reg [7:0] real_in3;
    reg reset;
    wire [7:0] imag_out0;
    wire [7:0] imag_out1;
    wire [7:0] imag_out2;
    wire [7:0] imag_out3;
    wire [7:0] real_out0;
    wire [7:0] real_out1;
    wire [7:0] real_out2;
    wire [7:0] real_out3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fft_4point dut (
        .clk(clk),
        .imag_in0(imag_in0),
        .imag_in1(imag_in1),
        .imag_in2(imag_in2),
        .imag_in3(imag_in3),
        .real_in0(real_in0),
        .real_in1(real_in1),
        .real_in2(real_in2),
        .real_in3(real_in3),
        .reset(reset),
        .imag_out0(imag_out0),
        .imag_out1(imag_out1),
        .imag_out2(imag_out2),
        .imag_out3(imag_out3),
        .real_out0(real_out0),
        .real_out1(real_out1),
        .real_out2(real_out2),
        .real_out3(real_out3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            real_in0 = 0; real_in1 = 0; real_in2 = 0; real_in3 = 0;
            imag_in0 = 0; imag_in1 = 0; imag_in2 = 0; imag_in3 = 0;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Impulse at x[0]", test_num);
            real_in0 = 8'h01; real_in1 = 8'h00; real_in2 = 8'h00; real_in3 = 8'h00;
            imag_in0 = 8'h00; imag_in1 = 8'h00; imag_in2 = 8'h00; imag_in3 = 8'h00;

            repeat(2) @(posedge clk); #2;

            #1;


            check_outputs(
                8'h00, 8'h00, 8'h00, 8'h00,
                8'h01, 8'h01, 8'h01, 8'h01
            );
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: DC Signal", test_num);
            real_in0 = 8'h04; real_in1 = 8'h04; real_in2 = 8'h04; real_in3 = 8'h04;
            imag_in0 = 8'h00; imag_in1 = 8'h00; imag_in2 = 8'h00; imag_in3 = 8'h00;

            repeat(2) @(posedge clk); #2;

            #1;


            check_outputs(
                8'h00, 8'h00, 8'h00, 8'h00,
                8'h10, 8'h00, 8'h00, 8'h00
            );
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Alternating Real Sequence", test_num);
            real_in0 = 8'd10;  real_in1 = -8'd10; real_in2 = 8'd10;  real_in3 = -8'd10;
            imag_in0 = 8'h00;  imag_in1 = 8'h00;  imag_in2 = 8'h00;  imag_in3 = 8'h00;

            repeat(2) @(posedge clk); #2;

            #1;


            check_outputs(
                8'h00, 8'h00, 8'h00, 8'h00,
                8'h00, 8'h00, 8'd40, 8'h00
            );
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Complex Exponential (f=1)", test_num);
            real_in0 = 8'd1;  real_in1 = 8'd0;  real_in2 = -8'd1; real_in3 = 8'd0;
            imag_in0 = 8'd0;  imag_in1 = 8'd1;  imag_in2 = 8'd0;  imag_in3 = -8'd1;

            repeat(2) @(posedge clk); #2;






            #1;







            check_outputs(
                8'h00, 8'h00, 8'h00, 8'h00,
                8'h00, 8'h04, 8'h00, 8'h00
            );
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: All Zeros", test_num);
            real_in0 = 8'h00; real_in1 = 8'h00; real_in2 = 8'h00; real_in3 = 8'h00;
            imag_in0 = 8'h00; imag_in1 = 8'h00; imag_in2 = 8'h00; imag_in3 = 8'h00;

            repeat(2) @(posedge clk); #2;

            #1;


            check_outputs(
                8'h00, 8'h00, 8'h00, 8'h00,
                8'h00, 8'h00, 8'h00, 8'h00
            );
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Imaginary DC Signal", test_num);
            real_in0 = 8'h00; real_in1 = 8'h00; real_in2 = 8'h00; real_in3 = 8'h00;
            imag_in0 = 8'd2;  imag_in1 = 8'd2;  imag_in2 = 8'd2;  imag_in3 = 8'd2;

            repeat(2) @(posedge clk); #2;

            #1;


            check_outputs(
                8'h08, 8'h00, 8'h00, 8'h00,
                8'h00, 8'h00, 8'h00, 8'h00
            );
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
        input [7:0] expected_imag_out0;
        input [7:0] expected_imag_out1;
        input [7:0] expected_imag_out2;
        input [7:0] expected_imag_out3;
        input [7:0] expected_real_out0;
        input [7:0] expected_real_out1;
        input [7:0] expected_real_out2;
        input [7:0] expected_real_out3;
        begin
            if (expected_imag_out0 === (expected_imag_out0 ^ imag_out0 ^ expected_imag_out0) &&
                expected_imag_out1 === (expected_imag_out1 ^ imag_out1 ^ expected_imag_out1) &&
                expected_imag_out2 === (expected_imag_out2 ^ imag_out2 ^ expected_imag_out2) &&
                expected_imag_out3 === (expected_imag_out3 ^ imag_out3 ^ expected_imag_out3) &&
                expected_real_out0 === (expected_real_out0 ^ real_out0 ^ expected_real_out0) &&
                expected_real_out1 === (expected_real_out1 ^ real_out1 ^ expected_real_out1) &&
                expected_real_out2 === (expected_real_out2 ^ real_out2 ^ expected_real_out2) &&
                expected_real_out3 === (expected_real_out3 ^ real_out3 ^ expected_real_out3)) begin
                $display("PASS");
                $display("  Outputs: imag_out0=%h, imag_out1=%h, imag_out2=%h, imag_out3=%h, real_out0=%h, real_out1=%h, real_out2=%h, real_out3=%h",
                         imag_out0, imag_out1, imag_out2, imag_out3, real_out0, real_out1, real_out2, real_out3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: imag_out0=%h, imag_out1=%h, imag_out2=%h, imag_out3=%h, real_out0=%h, real_out1=%h, real_out2=%h, real_out3=%h",
                         expected_imag_out0, expected_imag_out1, expected_imag_out2, expected_imag_out3, expected_real_out0, expected_real_out1, expected_real_out2, expected_real_out3);
                $display("  Got:      imag_out0=%h, imag_out1=%h, imag_out2=%h, imag_out3=%h, real_out0=%h, real_out1=%h, real_out2=%h, real_out3=%h",
                         imag_out0, imag_out1, imag_out2, imag_out3, real_out0, real_out1, real_out2, real_out3);
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
        $dumpvars(0,clk, imag_in0, imag_in1, imag_in2, imag_in3, real_in0, real_in1, real_in2, real_in3, reset, imag_out0, imag_out1, imag_out2, imag_out3, real_out0, real_out1, real_out2, real_out3);
    end

endmodule
