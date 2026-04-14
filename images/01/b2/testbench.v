`timescale 1ns/1ps

module fft_4point_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] imag_in;
    reg [3:0] real_in;
    reg reset;
    wire [3:0] imag_out;
    wire [3:0] real_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fft_4point dut (
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
            real_in = 0;
            imag_in = 0;
            test_num = test_num + 1;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Unit Impulse x[0]=1");
            reset_dut();


            real_in = 4'h1; imag_in = 4'h0; @(posedge clk); #1;
            real_in = 4'h0; imag_in = 4'h0; @(posedge clk); #1;
            real_in = 4'h0; imag_in = 4'h0; @(posedge clk); #1;
            real_in = 4'h0; imag_in = 4'h0; @(posedge clk); #1;


            $display("  Checking X[0]:"); #1;
 check_outputs(4'h0, 4'h1); @(posedge clk); #1;
            $display("  Checking X[1]:"); #1;
 check_outputs(4'h0, 4'h1); @(posedge clk); #1;
            $display("  Checking X[2]:"); #1;
 check_outputs(4'h0, 4'h1); @(posedge clk); #1;
            $display("  Checking X[3]:"); #1;
 check_outputs(4'h0, 4'h1); @(posedge clk); #1;
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: DC Signal");
            reset_dut();


            real_in = 4'h1; imag_in = 4'h0; @(posedge clk); #1;
            real_in = 4'h1; imag_in = 4'h0; @(posedge clk); #1;
            real_in = 4'h1; imag_in = 4'h0; @(posedge clk); #1;
            real_in = 4'h1; imag_in = 4'h0; @(posedge clk); #1;


            $display("  Checking X[0]:"); #1;
 check_outputs(4'h0, 4'h4); @(posedge clk); #1;
            $display("  Checking X[1]:"); #1;
 check_outputs(4'h0, 4'h0); @(posedge clk); #1;
            $display("  Checking X[2]:"); #1;
 check_outputs(4'h0, 4'h0); @(posedge clk); #1;
            $display("  Checking X[3]:"); #1;
 check_outputs(4'h0, 4'h0); @(posedge clk); #1;
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Complex Rotation");
            reset_dut();


            real_in = 4'h1; imag_in = 4'h0; @(posedge clk); #1;
            real_in = 4'h0; imag_in = 4'h1; @(posedge clk); #1;
            real_in = 4'hF; imag_in = 4'h0; @(posedge clk); #1;
            real_in = 4'h0; imag_in = 4'hF; @(posedge clk); #1;


            $display("  Checking X[0]:"); #1;
 check_outputs(4'h0, 4'h0); @(posedge clk); #1;
            $display("  Checking X[1]:"); #1;
 check_outputs(4'h0, 4'h4); @(posedge clk); #1;
            $display("  Checking X[2]:"); #1;
 check_outputs(4'h0, 4'h0); @(posedge clk); #1;
            $display("  Checking X[3]:"); #1;
 check_outputs(4'h0, 4'h0); @(posedge clk); #1;
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Alternating Signal");
            reset_dut();


            real_in = 4'h1; imag_in = 4'h0; @(posedge clk); #1;
            real_in = 4'hF; imag_in = 4'h0; @(posedge clk); #1;
            real_in = 4'h1; imag_in = 4'h0; @(posedge clk); #1;
            real_in = 4'hF; imag_in = 4'h0; @(posedge clk); #1;


            $display("  Checking X[0]:"); #1;
 check_outputs(4'h0, 4'h0); @(posedge clk); #1;
            $display("  Checking X[1]:"); #1;
 check_outputs(4'h0, 4'h0); @(posedge clk); #1;
            $display("  Checking X[2]:"); #1;
 check_outputs(4'h0, 4'h4); @(posedge clk); #1;
            $display("  Checking X[3]:"); #1;
 check_outputs(4'h0, 4'h0); @(posedge clk); #1;
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
        input [3:0] expected_imag_out;
        input [3:0] expected_real_out;
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
