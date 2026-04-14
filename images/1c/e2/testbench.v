`timescale 1ns/1ps

module fft_32_point_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] imag_in;
    reg [31:0] real_in;
    reg reset;
    reg start;
    reg valid_in;
    wire [31:0] imag_out;
    wire [31:0] real_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fft_32_point dut (
        .clk(clk),
        .imag_in(imag_in),
        .real_in(real_in),
        .reset(reset),
        .start(start),
        .valid_in(valid_in),
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
            reset = 1;
            start = 0;
            valid_in = 0;
            real_in = 0;
            imag_in = 0;
            repeat(5) @(posedge clk);
            reset = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        integer i;
        begin
            $display("\nRunning Testcase 001: Impulse Response (Real)");
            reset_dut();


            start = 1;
            @(posedge clk);
            start = 0;


            for (i = 0; i < 32; i = i + 1) begin
                valid_in = 1;
                if (i == 0) real_in = 32'h00000100;
                else        real_in = 32'h00000000;
                imag_in = 32'h00000000;
                @(posedge clk);
            end
            valid_in = 0;


            wait(valid_out);


            for (i = 0; i < 32; i = i + 1) begin
                #1;

                check_outputs(32'h00000000, 32'h00000100, 1'b1);
                @(posedge clk);
            end
        end
        endtask

    task testcase002;

        integer i;
        begin
            $display("\nRunning Testcase 002: Zero Input");
            reset_dut();

            start = 1;
            @(posedge clk);
            start = 0;

            for (i = 0; i < 32; i = i + 1) begin
                valid_in = 1;
                real_in = 32'h0;
                imag_in = 32'h0;
                @(posedge clk);
            end
            valid_in = 0;

            wait(valid_out);

            for (i = 0; i < 32; i = i + 1) begin
                #1;

                check_outputs(32'h0, 32'h0, 1'b1);
                @(posedge clk);
            end
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("\nRunning Testcase 003: DC Signal");
            reset_dut();

            start = 1;
            @(posedge clk);
            start = 0;

            for (i = 0; i < 32; i = i + 1) begin
                valid_in = 1;
                real_in = 32'h00000010;
                imag_in = 32'h0;
                @(posedge clk);
            end
            valid_in = 0;

            wait(valid_out);

            for (i = 0; i < 32; i = i + 1) begin
                if (i == 0)
                    #1;

                    check_outputs(32'h0, 32'h00000200, 1'b1);
                else
                    #1;

                    check_outputs(32'h0, 32'h0, 1'b1);
                @(posedge clk);
            end
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("\nRunning Testcase 004: Imaginary Impulse");
            reset_dut();

            start = 1;
            @(posedge clk);
            start = 0;

            for (i = 0; i < 32; i = i + 1) begin
                valid_in = 1;
                real_in = 32'h0;
                if (i == 0) imag_in = 32'h00000100;
                else        imag_in = 32'h0;
                @(posedge clk);
            end
            valid_in = 0;

            wait(valid_out);

            for (i = 0; i < 32; i = i + 1) begin
                #1;

                check_outputs(32'h00000100, 32'h0, 1'b1);
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
        $display("fft_32_point Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [31:0] expected_imag_out;
        input [31:0] expected_real_out;
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
        $dumpvars(0,clk, imag_in, real_in, reset, start, valid_in, imag_out, real_out, valid_out);
    end

endmodule
