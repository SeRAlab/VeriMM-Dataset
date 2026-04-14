`timescale 1ns/1ps

module fft_64_point_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] imag_in;
    reg [15:0] real_in;
    reg rst;
    reg valid;
    wire [15:0] imag_out;
    wire ready;
    wire [15:0] real_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fft_64_point dut (
        .clk(clk),
        .imag_in(imag_in),
        .real_in(real_in),
        .rst(rst),
        .valid(valid),
        .imag_out(imag_out),
        .ready(ready),
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
            valid = 0;
            real_in = 0;
            imag_in = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        integer i;
        begin
            $display("\nRunning testcase001: Impulse Response");
            reset_dut();
            test_num = test_num + 1;


            for (i = 0; i < 64; i = i + 1) begin
                valid = 1;
                if (i == 0)
                    real_in = 16'sd1024;
                else
                    real_in = 16'sd0;
                imag_in = 16'sd0;
                @(posedge clk);
                #1;
            end
            valid = 0;



            wait(ready == 1'b1);

            for (i = 0; i < 64; i = i + 1) begin

                #1;


                check_outputs(16'sd0, 1'b1, 16'sd1024);
                @(posedge clk);
                #1;
            end
        end
        endtask

    task testcase002;

        integer i;
        begin
            $display("\nRunning testcase002: DC Signal");
            reset_dut();
            test_num = test_num + 1;


            for (i = 0; i < 64; i = i + 1) begin
                valid = 1;
                real_in = 16'sd100;
                imag_in = 16'sd0;
                @(posedge clk);
                #1;
            end
            valid = 0;


            wait(ready == 1'b1);

            for (i = 0; i < 64; i = i + 1) begin
                if (i == 0)
                    #1;

                    check_outputs(16'sd0, 1'b1, 16'sd6400);
                else
                    #1;

                    check_outputs(16'sd0, 1'b1, 16'sd0);
                @(posedge clk);
                #1;
            end
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("\nRunning testcase003: All Zero Input");
            reset_dut();
            test_num = test_num + 1;

            for (i = 0; i < 64; i = i + 1) begin
                valid = 1;
                real_in = 16'sd0;
                imag_in = 16'sd0;
                @(posedge clk);
                #1;
            end
            valid = 0;

            wait(ready == 1'b1);

            for (i = 0; i < 64; i = i + 1) begin
                #1;

                check_outputs(16'sd0, 1'b1, 16'sd0);
                @(posedge clk);
                #1;
            end
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("\nRunning testcase004: Imaginary DC Signal");
            reset_dut();
            test_num = test_num + 1;

            for (i = 0; i < 64; i = i + 1) begin
                valid = 1;
                real_in = 16'sd0;
                imag_in = 16'sd50;
                @(posedge clk);
                #1;
            end
            valid = 0;

            wait(ready == 1'b1);

            for (i = 0; i < 64; i = i + 1) begin
                if (i == 0)
                    #1;

                    check_outputs(16'sd3200, 1'b1, 16'sd0);
                else
                    #1;

                    check_outputs(16'sd0, 1'b1, 16'sd0);
                @(posedge clk);
                #1;
            end
        end
        endtask

    task testcase005;

        integer i;
        begin
            $display("\nRunning testcase005: Complex Constant");
            reset_dut();
            test_num = test_num + 1;

            for (i = 0; i < 64; i = i + 1) begin
                valid = 1;
                real_in = 16'sd10;
                imag_in = 16'sd10;
                @(posedge clk);
                #1;
            end
            valid = 0;

            wait(ready == 1'b1);

            for (i = 0; i < 64; i = i + 1) begin
                if (i == 0)
                    #1;

                    check_outputs(16'sd640, 1'b1, 16'sd640);
                else
                    #1;

                    check_outputs(16'sd0, 1'b1, 16'sd0);
                @(posedge clk);
                #1;
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fft_64_point Testbench");
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
        input expected_ready;
        input [15:0] expected_real_out;
        begin
            if (expected_imag_out === (expected_imag_out ^ imag_out ^ expected_imag_out) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready) &&
                expected_real_out === (expected_real_out ^ real_out ^ expected_real_out)) begin
                $display("PASS");
                $display("  Outputs: imag_out=%h, ready=%b, real_out=%h",
                         imag_out, ready, real_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: imag_out=%h, ready=%b, real_out=%h",
                         expected_imag_out, expected_ready, expected_real_out);
                $display("  Got:      imag_out=%h, ready=%b, real_out=%h",
                         imag_out, ready, real_out);
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
        $dumpvars(0,clk, imag_in, real_in, rst, valid, imag_out, ready, real_out);
    end

endmodule
