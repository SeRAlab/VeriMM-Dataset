`timescale 1ns/1ps

module adaptive_lms_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] d;
    reg rst;
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
        .rst(rst),
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
            rst = 1;
            x = 16'h0;
            d = 16'h0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase 001: Reset State Check...");
            reset_dut();

            #1;


            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase 002: Initial Calculation (Weights=0)...");
            reset_dut();
            x = 16'h1000;
            d = 16'h2000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h2000, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase 003: Zero Desired Signal...");
            reset_dut();
            x = 16'h0000;
            d = 16'h0000;
            @(posedge clk);

            #1;


            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase 004: Weight Adaptation Trend...");
            reset_dut();


            x = 16'h0001;
            d = 16'h0001;
            @(posedge clk);
            #1;



            @(posedge clk);
            #1;

            if (y != 16'h0000) begin
                $display("PASS: Filter started adapting (y changed from zero)");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Filter weights stuck at zero");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase 005: Full Scale Reset...");
            reset_dut();
            x = 16'h7FFF;
            d = 16'h7FFF;
            repeat(5) @(posedge clk);

            reset_dut();
            #1;

            check_outputs(16'h0000, 16'h0000);
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
        $dumpvars(0,clk, d, rst, x, error, y);
    end

endmodule
