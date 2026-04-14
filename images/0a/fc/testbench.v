`timescale 1ns/1ps

module fft_4point_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a_imag;
    reg [15:0] a_real;
    reg [15:0] b_imag;
    reg [15:0] b_real;
    reg [15:0] c_imag;
    reg [15:0] c_real;
    reg [15:0] d_imag;
    reg [15:0] d_real;
    wire [15:0] out0_imag;
    wire [15:0] out0_real;
    wire [15:0] out1_imag;
    wire [15:0] out1_real;
    wire [15:0] out2_imag;
    wire [15:0] out2_real;
    wire [15:0] out3_imag;
    wire [15:0] out3_real;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fft_4point dut (
        .a_imag(a_imag),
        .a_real(a_real),
        .b_imag(b_imag),
        .b_real(b_real),
        .c_imag(c_imag),
        .c_real(c_real),
        .d_imag(d_imag),
        .d_real(d_real),
        .out0_imag(out0_imag),
        .out0_real(out0_real),
        .out1_imag(out1_imag),
        .out1_real(out1_real),
        .out2_imag(out2_imag),
        .out2_real(out2_real),
        .out3_imag(out3_imag),
        .out3_real(out3_real)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Unit impulse at x[0] (x=[1, 0, 0, 0])", test_num);
        a_real = 16'd1; a_imag = 16'd0;
        b_real = 16'd0; b_imag = 16'd0;
        c_real = 16'd0; c_imag = 16'd0;
        d_real = 16'd0; d_imag = 16'd0;

        #1;


        check_outputs(16'd0, 16'd1, 16'd0, 16'd1, 16'd0, 16'd1, 16'd0, 16'd1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: DC signal (x=[1, 1, 1, 1])", test_num);
        a_real = 16'd1; a_imag = 16'd0;
        b_real = 16'd1; b_imag = 16'd0;
        c_real = 16'd1; c_imag = 16'd0;
        d_real = 16'd1; d_imag = 16'd0;

        #1;


        check_outputs(16'd0, 16'd4, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Complex sinusoid k=1 (x=[1, j, -1, -j])", test_num);
        a_real = 16'd1;    a_imag = 16'd0;
        b_real = 16'd0;    b_imag = 16'd1;
        c_real = 16'hFFFF; c_imag = 16'd0;
        d_real = 16'd0;    d_imag = 16'hFFFF;

        #1;


        check_outputs(16'd0, 16'd0, 16'd0, 16'd4, 16'd0, 16'd0, 16'd0, 16'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Real sequence x=[2, 1, 0, -1]", test_num);
        a_real = 16'd2;    a_imag = 16'd0;
        b_real = 16'd1;    b_imag = 16'd0;
        c_real = 16'd0;    c_imag = 16'd0;
        d_real = 16'hFFFF; d_imag = 16'd0;





        #1;






        check_outputs(16'd0, 16'd2, 16'hFFFE, 16'd2, 16'd0, 16'd2, 16'd2, 16'd2);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: All zeros", test_num);
        a_real = 16'd0; a_imag = 16'd0;
        b_real = 16'd0; b_imag = 16'd0;
        c_real = 16'd0; c_imag = 16'd0;
        d_real = 16'd0; d_imag = 16'd0;
        #1;

        check_outputs(16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: DC signal with Imaginary part (x=[1+j, 1+j, 1+j, 1+j])", test_num);
        a_real = 16'd1; a_imag = 16'd1;
        b_real = 16'd1; b_imag = 16'd1;
        c_real = 16'd1; c_imag = 16'd1;
        d_real = 16'd1; d_imag = 16'd1;

        #1;


        check_outputs(16'd4, 16'd4, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: High frequency real signal (x=[1, -1, 1, -1])", test_num);
        a_real = 16'd1;    a_imag = 16'd0;
        b_real = 16'hFFFF; b_imag = 16'd0;
        c_real = 16'd1;    c_imag = 16'd0;
        d_real = 16'hFFFF; d_imag = 16'd0;

        #1;


        check_outputs(16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd4, 16'd0, 16'd0);
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
        input [15:0] expected_out0_imag;
        input [15:0] expected_out0_real;
        input [15:0] expected_out1_imag;
        input [15:0] expected_out1_real;
        input [15:0] expected_out2_imag;
        input [15:0] expected_out2_real;
        input [15:0] expected_out3_imag;
        input [15:0] expected_out3_real;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out0_imag === (expected_out0_imag ^ out0_imag ^ expected_out0_imag) &&
                expected_out0_real === (expected_out0_real ^ out0_real ^ expected_out0_real) &&
                expected_out1_imag === (expected_out1_imag ^ out1_imag ^ expected_out1_imag) &&
                expected_out1_real === (expected_out1_real ^ out1_real ^ expected_out1_real) &&
                expected_out2_imag === (expected_out2_imag ^ out2_imag ^ expected_out2_imag) &&
                expected_out2_real === (expected_out2_real ^ out2_real ^ expected_out2_real) &&
                expected_out3_imag === (expected_out3_imag ^ out3_imag ^ expected_out3_imag) &&
                expected_out3_real === (expected_out3_real ^ out3_real ^ expected_out3_real)) begin
                $display("PASS");
                $display("  Outputs: out0_imag=%h, out0_real=%h, out1_imag=%h, out1_real=%h, out2_imag=%h, out2_real=%h, out3_imag=%h, out3_real=%h",
                         out0_imag, out0_real, out1_imag, out1_real, out2_imag, out2_real, out3_imag, out3_real);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out0_imag=%h, out0_real=%h, out1_imag=%h, out1_real=%h, out2_imag=%h, out2_real=%h, out3_imag=%h, out3_real=%h",
                         expected_out0_imag, expected_out0_real, expected_out1_imag, expected_out1_real, expected_out2_imag, expected_out2_real, expected_out3_imag, expected_out3_real);
                $display("  Got:      out0_imag=%h, out0_real=%h, out1_imag=%h, out1_real=%h, out2_imag=%h, out2_real=%h, out3_imag=%h, out3_real=%h",
                         out0_imag, out0_real, out1_imag, out1_real, out2_imag, out2_real, out3_imag, out3_real);
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

endmodule
