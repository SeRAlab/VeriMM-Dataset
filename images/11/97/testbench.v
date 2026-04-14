`timescale 1ns/1ps

module fft_butterfly_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a_imag;
    reg [7:0] a_real;
    reg [7:0] b_imag;
    reg [7:0] b_real;
    reg clk;
    reg rst;
    reg [7:0] w_imag;
    reg [7:0] w_real;
    wire [7:0] out1_imag;
    wire [7:0] out1_real;
    wire [7:0] out2_imag;
    wire [7:0] out2_real;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fft_butterfly dut (
        .a_imag(a_imag),
        .a_real(a_real),
        .b_imag(b_imag),
        .b_real(b_real),
        .clk(clk),
        .rst(rst),
        .w_imag(w_imag),
        .w_real(w_real),
        .out1_imag(out1_imag),
        .out1_real(out1_real),
        .out2_imag(out2_imag),
        .out2_real(out2_real)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            a_imag = 0;
            a_real = 0;
            b_imag = 0;
            b_real = 0;
            w_imag = 0;
            w_real = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Running Testcase%03d: Identity W=1", test_num);
            a_real = 8'd10;  a_imag = 8'd2;
            b_real = 8'd5;   b_imag = 8'd3;
            w_real = 8'd1;   w_imag = 8'd0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h05, 8'h0F, 8'hFF, 8'h05);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Running Testcase%03d: Rotation by W=j", test_num);
            a_real = 8'd20;  a_imag = 8'd10;
            b_real = 8'd4;   b_imag = 8'd2;
            w_real = 8'd0;   w_imag = 8'd1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h0E, 8'h12, 8'h06, 8'h16);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Running Testcase%03d: All Zeros", test_num);
            a_real = 8'h00;  a_imag = 8'h00;
            b_real = 8'h00;  b_imag = 8'h00;
            w_real = 8'h00;  w_imag = 8'h00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Running Testcase%03d: Negative Real W=-1", test_num);
            a_real = 8'd10;   a_imag = 8'd10;
            b_real = 8'd5;    b_imag = 8'd5;
            w_real = 8'hFF;   w_imag = 8'h00;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h05, 8'h05, 8'h0F, 8'h0F);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Running Testcase%03d: Complex Mix", test_num);
            a_real = 8'd0;    a_imag = 8'd0;
            b_real = 8'd2;    b_imag = 8'd2;
            w_real = 8'd2;    w_imag = 8'd3;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h0A, 8'hFE, 8'hF6, 8'h02);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fft_butterfly Testbench");
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
        input [7:0] expected_out1_imag;
        input [7:0] expected_out1_real;
        input [7:0] expected_out2_imag;
        input [7:0] expected_out2_real;
        begin
            if (expected_out1_imag === (expected_out1_imag ^ out1_imag ^ expected_out1_imag) &&
                expected_out1_real === (expected_out1_real ^ out1_real ^ expected_out1_real) &&
                expected_out2_imag === (expected_out2_imag ^ out2_imag ^ expected_out2_imag) &&
                expected_out2_real === (expected_out2_real ^ out2_real ^ expected_out2_real)) begin
                $display("PASS");
                $display("  Outputs: out1_imag=%h, out1_real=%h, out2_imag=%h, out2_real=%h",
                         out1_imag, out1_real, out2_imag, out2_real);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out1_imag=%h, out1_real=%h, out2_imag=%h, out2_real=%h",
                         expected_out1_imag, expected_out1_real, expected_out2_imag, expected_out2_real);
                $display("  Got:      out1_imag=%h, out1_real=%h, out2_imag=%h, out2_real=%h",
                         out1_imag, out1_real, out2_imag, out2_real);
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
        $dumpvars(0,a_imag, a_real, b_imag, b_real, clk, rst, w_imag, w_real, out1_imag, out1_real, out2_imag, out2_real);
    end

endmodule
