`timescale 1ns/1ps

module fft_example_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] imag_in;
    reg [15:0] real_in;
    reg rst;
    wire [15:0] imag_out;
    wire [15:0] real_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fft_example dut (
        .clk(clk),
        .imag_in(imag_in),
        .real_in(real_in),
        .rst(rst),
        .imag_out(imag_out),
        .real_out(real_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            real_in = 16'd0;
            imag_in = 16'd0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Zero Input Signal", test_num);
            reset_dut();

            real_in = 16'h0000;
            imag_in = 16'h0000;

            @(posedge clk);
            #2;


            #1;



            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Real-only DC Component", test_num);
            reset_dut();

            real_in = 16'h1000;
            imag_in = 16'h0000;

            @(posedge clk);
            #2;


            #1;



            check_outputs(16'h0000, 16'h1000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Imaginary-only Component", test_num);
            reset_dut();

            real_in = 16'h0000;
            imag_in = 16'h2000;

            @(posedge clk);
            #2;

            #1;


            check_outputs(16'h2000, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Negative Complex Input", test_num);
            reset_dut();

            real_in = 16'hFFFF;
            imag_in = 16'hFFFE;

            @(posedge clk);
            #2;

            #1;


            check_outputs(16'hFFFE, 16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Maximum Magnitude", test_num);
            reset_dut();

            real_in = 16'h7FFF;
            imag_in = 16'h8000;

            @(posedge clk);
            #2;

            #1;


            check_outputs(16'h8000, 16'h7FFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fft_example Testbench");
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
        input [15:0] expected_imag_out;
        input [15:0] expected_real_out;
        begin
            if (expected_imag_out === (expected_imag_out ^ imag_out ^ expected_imag_out) &&
                expected_real_out === (expected_real_out ^ real_out ^ expected_real_out)) begin
                $display("PASS");
                $display("  Outputs: imag_out=%h, real_out=%h",
                         imag_out, real_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: imag_out=%h, real_out=%h",
                         expected_imag_out, expected_real_out);
                $display("  Got:      imag_out=%h, real_out=%h",
                         imag_out, real_out);
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
        $dumpvars(0,clk, imag_in, real_in, rst, imag_out, real_out);
    end

endmodule
