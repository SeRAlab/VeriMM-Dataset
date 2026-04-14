`timescale 1ns/1ps

module fft_64_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] imag_in;
    reg [63:0] real_in;
    reg reset;
    reg start;
    wire done;
    wire [63:0] imag_out;
    wire [63:0] real_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fft_64 dut (
        .clk(clk),
        .imag_in(imag_in),
        .real_in(real_in),
        .reset(reset),
        .start(start),
        .done(done),
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
            start = 0;
            real_in = 0;
            imag_in = 0;
            repeat (5) @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: All Zeros Input");
            reset_dut();

            @(posedge clk);
            start = 1;

            for (i = 0; i < 64; i = i + 1) begin
                real_in = 64'h0;
                imag_in = 64'h0;
                @(posedge clk);
                start = 0;
            end


            wait(done);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 64'h0, 64'h0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: DC Signal (Constant Real)");
            reset_dut();

            @(posedge clk);
            start = 1;

            for (i = 0; i < 64; i = i + 1) begin
                real_in = 64'h0000_0000_0000_0001;
                imag_in = 64'h0;
                @(posedge clk);
                start = 0;
            end

            wait(done);
            @(posedge clk);





            #1;






            check_outputs(1'b1, 64'h0, 64'h0000_0000_0000_0040);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Time-Domain Impulse");
            reset_dut();

            @(posedge clk);
            start = 1;

            for (i = 0; i < 64; i = i + 1) begin
                if (i == 0) real_in = 64'h0000_0000_0000_0001;
                else        real_in = 64'h0;
                imag_in = 64'h0;
                @(posedge clk);
                start = 0;
            end

            wait(done);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 64'h0, 64'h0000_0000_0000_0001);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Imaginary DC Signal");
            reset_dut();

            @(posedge clk);
            start = 1;
            for (i = 0; i < 64; i = i + 1) begin
                real_in = 64'h0;
                imag_in = 64'h0000_0000_0000_0001;
                @(posedge clk);
                start = 0;
            end

            wait(done);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 64'h0000_0000_0000_0040, 64'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fft_64 Testbench");
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
        input expected_done;
        input [63:0] expected_imag_out;
        input [63:0] expected_real_out;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_imag_out === (expected_imag_out ^ imag_out ^ expected_imag_out) &&
                expected_real_out === (expected_real_out ^ real_out ^ expected_real_out)) begin
                $display("PASS");
                $display("  Outputs: done=%b, imag_out=%h, real_out=%h",
                         done, imag_out, real_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, imag_out=%h, real_out=%h",
                         expected_done, expected_imag_out, expected_real_out);
                $display("  Got:      done=%b, imag_out=%h, real_out=%h",
                         done, imag_out, real_out);
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
        $dumpvars(0,clk, imag_in, real_in, reset, start, done, imag_out, real_out);
    end

endmodule
