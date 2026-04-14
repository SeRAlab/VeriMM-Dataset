`timescale 1ns/1ps

module fft_butterfly_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] input1_imag;
    reg [15:0] input1_real;
    reg [15:0] input2_imag;
    reg [15:0] input2_real;
    reg rst;
    reg [15:0] twiddle_imag;
    reg [15:0] twiddle_real;
    wire [15:0] output1_imag;
    wire [15:0] output1_real;
    wire [15:0] output2_imag;
    wire [15:0] output2_real;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fft_butterfly dut (
        .clk(clk),
        .input1_imag(input1_imag),
        .input1_real(input1_real),
        .input2_imag(input2_imag),
        .input2_real(input2_real),
        .rst(rst),
        .twiddle_imag(twiddle_imag),
        .twiddle_real(twiddle_real),
        .output1_imag(output1_imag),
        .output1_real(output1_real),
        .output2_imag(output2_imag),
        .output2_real(output2_real)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            input1_imag = 0;
            input1_real = 0;
            input2_imag = 0;
            input2_real = 0;
            twiddle_imag = 0;
            twiddle_real = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Identity rotation (W=1+0j)", test_num);
            reset_dut();
            input1_real = 16'd10; input1_imag = 16'd20;
            input2_real = 16'd5;  input2_imag = -16'd5;
            twiddle_real = 16'd1; twiddle_imag = 16'd0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'd15, 16'd15, 16'd25, 16'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 90 degree rotation (W=0+1j)", test_num);
            reset_dut();
            input1_real = 16'd100; input1_imag = 16'd100;
            input2_real = 16'd50;  input2_imag = 16'd20;
            twiddle_real = 16'd0;   twiddle_imag = 16'd1;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'd150, 16'd80, 16'd50, 16'd120);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All inputs zero", test_num);
            reset_dut();
            input1_real = 16'd0; input1_imag = 16'd0;
            input2_real = 16'd0; input2_imag = 16'd0;
            twiddle_real = 16'd50; twiddle_imag = 16'd50;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'd0, 16'd0, 16'd0, 16'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative values and W=-1", test_num);
            reset_dut();
            input1_real = -16'd10; input1_imag = -16'd10;
            input2_real = 16'd10;  input2_imag = 16'd10;
            twiddle_real = -16'd1; twiddle_imag = 16'd0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(-16'd20, -16'd20, 16'd0, 16'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Complex twiddle product", test_num);
            reset_dut();
            input1_real = 16'd5; input1_imag = 16'd5;
            input2_real = 16'd2; input2_imag = 16'd2;
            twiddle_real = 16'd2; twiddle_imag = -16'd2;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'd5, 16'd13, 16'd5, -16'd3);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Imaginary B and W interaction", test_num);
            reset_dut();
            input1_real = 16'd1000; input1_imag = 16'd0;
            input2_real = 16'd0;    input2_imag = 16'd50;
            twiddle_real = 16'd0;   twiddle_imag = -16'd10;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'd0, 16'd1500, 16'd0, 16'd500);
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
        input [15:0] expected_output1_imag;
        input [15:0] expected_output1_real;
        input [15:0] expected_output2_imag;
        input [15:0] expected_output2_real;
        begin
            if (expected_output1_imag === (expected_output1_imag ^ output1_imag ^ expected_output1_imag) &&
                expected_output1_real === (expected_output1_real ^ output1_real ^ expected_output1_real) &&
                expected_output2_imag === (expected_output2_imag ^ output2_imag ^ expected_output2_imag) &&
                expected_output2_real === (expected_output2_real ^ output2_real ^ expected_output2_real)) begin
                $display("PASS");
                $display("  Outputs: output1_imag=%h, output1_real=%h, output2_imag=%h, output2_real=%h",
                         output1_imag, output1_real, output2_imag, output2_real);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output1_imag=%h, output1_real=%h, output2_imag=%h, output2_real=%h",
                         expected_output1_imag, expected_output1_real, expected_output2_imag, expected_output2_real);
                $display("  Got:      output1_imag=%h, output1_real=%h, output2_imag=%h, output2_real=%h",
                         output1_imag, output1_real, output2_imag, output2_real);
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
        $dumpvars(0,clk, input1_imag, input1_real, input2_imag, input2_real, rst, twiddle_imag, twiddle_real, output1_imag, output1_real, output2_imag, output2_real);
    end

endmodule
