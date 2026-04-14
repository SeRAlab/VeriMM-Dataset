`timescale 1ns/1ps

module fft_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] imag_in;
    reg [15:0] real_in;
    reg rst;
    reg valid;
    wire [15:0] imag_out;
    wire [15:0] real_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fft dut (
        .clk(clk),
        .imag_in(imag_in),
        .real_in(real_in),
        .rst(rst),
        .valid(valid),
        .imag_out(imag_out),
        .real_out(real_out),
        .valid_out(valid_out)
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
            repeat(5) @(posedge clk);
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Impulse Response");
            reset_dut();


            @(posedge clk);
            real_in = SCALE;
            imag_in = 16'h0000;
            valid = 1;
            @(posedge clk);


            real_in = 16'h0000;
            repeat(N-1) @(posedge clk);
            valid = 0;


            wait(valid_out);



            for (i = 0; i < N; i = i + 1) begin
                #1;

                check_outputs(16'h0000, SCALE, 1'b1);
                @(posedge clk);
            end
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: DC Signal");
            reset_dut();


            @(posedge clk);
            real_in = SCALE;
            imag_in = 16'h0000;
            valid = 1;
            repeat(N) @(posedge clk);
            valid = 0;


            wait(valid_out);


            #1;



            check_outputs(16'h0000, SCALE * N, 1'b1);
            @(posedge clk);


            repeat(N-1) begin
                #1;

                check_outputs(16'h0000, 16'h0000, 1'b1);
                @(posedge clk);
            end
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: All Zeros");
            reset_dut();

            @(posedge clk);
            real_in = 16'h0000;
            imag_in = 16'h0000;
            valid = 1;
            repeat(N) @(posedge clk);
            valid = 0;

            wait(valid_out);

            repeat(N) begin
                #1;

                check_outputs(16'h0000, 16'h0000, 1'b1);
                @(posedge clk);
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
        $display("fft Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        
        
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
        input expected_valid_out;
        begin
            if (expected_imag_out === (expected_imag_out ^ imag_out ^ expected_imag_out) &&
                expected_real_out === (expected_real_out ^ real_out ^ expected_real_out) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: imag_out=%h, real_out=%h, valid_out=%b",
                         imag_out, real_out, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: imag_out=%h, real_out=%h, valid_out=%b",
                         expected_imag_out, expected_real_out, expected_valid_out);
                $display("  Got:      imag_out=%h, real_out=%h, valid_out=%b",
                         imag_out, real_out, valid_out);
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
        $dumpvars(0,clk, imag_in, real_in, rst, valid, imag_out, real_out, valid_out);
    end

endmodule
