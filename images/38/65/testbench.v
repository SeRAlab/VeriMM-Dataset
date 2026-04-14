`timescale 1ns/1ps

module fft_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] imag_in;
    reg [31:0] real_in;
    reg reset;
    wire [31:0] imag_out;
    wire [31:0] real_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fft_processor dut (
        .clk(clk),
        .imag_in(imag_in),
        .real_in(real_in),
        .reset(reset),
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
            reset = 1;
            real_in = 32'h0;
            imag_in = 32'h0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: All Zeros");
            reset_dut();
            for (i = 0; i < 32; i = i + 1) begin
                real_in = 32'h0;
                imag_in = 32'h0;
                @(posedge clk);
            end

            repeat(5) @(posedge clk);
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Real DC Signal");
            reset_dut();
            for (i = 0; i < 32; i = i + 1) begin
                real_in = 32'h0000_0001;
                imag_in = 32'h0000_0000;
                @(posedge clk);
            end
            repeat(5) @(posedge clk);


            if (real_out != 32'h0 && imag_out == 32'h0)
                pass_count = pass_count + 0;



            #1;




            check_outputs(32'h0000_0000, 32'h0000_0020);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Imaginary DC Signal");
            reset_dut();
            for (i = 0; i < 32; i = i + 1) begin
                real_in = 32'h0000_0000;
                imag_in = 32'h0000_0001;
                @(posedge clk);
            end
            repeat(5) @(posedge clk);

            #1;


            check_outputs(32'h0000_0020, 32'h0000_0000);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Real Unit Impulse");
            reset_dut();

            real_in = 32'h0000_0001;
            imag_in = 32'h0000_0000;
            @(posedge clk);
            for (i = 1; i < 32; i = i + 1) begin
                real_in = 32'h0;
                imag_in = 32'h0;
                @(posedge clk);
            end
            repeat(5) @(posedge clk);

            #1;


            check_outputs(32'h0000_0000, 32'h0000_0001);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Complex Large Values");
            reset_dut();
            for (i = 0; i < 32; i = i + 1) begin
                real_in = 32'h0000_0100;
                imag_in = 32'h0000_0100;
                @(posedge clk);
            end
            repeat(5) @(posedge clk);

            #1;


            check_outputs(32'h0000_2000, 32'h0000_2000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fft_processor Testbench");
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
        input [31:0] expected_imag_out;
        input [31:0] expected_real_out;
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
        $dumpvars(0,clk, imag_in, real_in, reset, imag_out, real_out);
    end

endmodule
