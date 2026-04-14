`timescale 1ns/1ps

module adaptive_lms_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] d;
    reg reset;
    reg [15:0] x;
    wire [15:0] error;
    wire [15:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adaptive_lms_filter dut (
        .clk(clk),
        .d(d),
        .reset(reset),
        .x(x),
        .error(error),
        .y(y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            x = 16'h0000;
            d = 16'h0000;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset and Zero Inputs...");
            test_num = 1;
            reset_dut();

            x = 16'h0000;
            d = 16'h0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Initial Error (Weights = 0)...");
            test_num = 2;
            reset_dut();
            x = 16'h0010;
            d = 16'h0050;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0050, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Zero Input Signal (x=0)...");
            test_num = 3;
            reset_dut();
            x = 16'h0000;
            d = 16'h1234;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h1234, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Negative Desired Signal...");
            test_num = 4;
            reset_dut();
            x = 16'h0005;
            d = 16'hFFFE;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hFFFE, 16'h0000);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Multi-cycle steady inputs...");
            test_num = 5;
            reset_dut();


            x = 16'h0100;
            d = 16'h0200;
            @(posedge clk);
            #1;






            x = 16'h0100;
            d = 16'h0200;
            @(posedge clk);
            #1;



            if (error + y == d) begin
                $display("PASS: Invariant d = y + error maintained.");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Sum of error (%h) and y (%h) does not match d (%h)", error, y, d);
                fail_count = fail_count + 1;
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
        $display("adaptive_lms_filter Testbench");
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
        input [15:0] expected_error;
        input [15:0] expected_y;
        begin
            if (expected_error === (expected_error ^ error ^ expected_error) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: error=%h, y=%h",
                         error, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: error=%h, y=%h",
                         expected_error, expected_y);
                $display("  Got:      error=%h, y=%h",
                         error, y);
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
        $dumpvars(0,clk, d, reset, x, error, y);
    end

endmodule
