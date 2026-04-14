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
        x = 0;
        d = 0;
        @(posedge clk);
        #1;
        rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: Reset State Verification", test_num);
        reset_dut();

        x = 16'h1000;
        d = 16'h2000;
        @(posedge clk);
        #1;


        #1;



        check_outputs(16'h2000, 16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: Zero Input Signal", test_num);
        reset_dut();

        x = 16'h0000;
        d = 16'h1234;

        repeat(5) @(posedge clk);
        #1;


        #1;



        check_outputs(16'h1234, 16'h0000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: Basic Adaptation (Non-zero output)", test_num);
        reset_dut();

        x = 16'h2000;
        d = 16'h4000;


        repeat(10) @(posedge clk);
        #1;



        if (y != 16'h0000 && (error == (d - y))) begin
            pass_count = pass_count + 1;
            $display("PASS: Adaptation active. y=%h, error=%h", y, error);
        end else begin
            fail_count = fail_count + 1;
            $display("FAIL: No adaptation or math error. y=%h, error=%h", y, error);
        end
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: Negative Signal Handling", test_num);
        reset_dut();

        x = 16'hF000;
        d = 16'hE000;

        repeat(5) @(posedge clk);
        #1;


        if (error == (d - y)) begin
            pass_count = pass_count + 1;
            $display("PASS: Signed math correct. x=%h, d=%h, y=%h, error=%h", x, d, y, error);
        end else begin
            fail_count = fail_count + 1;
            $display("FAIL: Signed math mismatch. y=%h, error=%h", y, error);
        end
    end
        endtask

    task testcase005;

    reg [15:0] initial_error;
    begin
        test_num = 5;
        $display("\nTestcase %0d: Convergence Trend", test_num);
        reset_dut();

        x = 16'h1000;
        d = 16'h3000;

        @(posedge clk);
        #1 initial_error = error;

        repeat(20) @(posedge clk);
        #1;



        if (error < initial_error || error[15] == 1) begin

            pass_count = pass_count + 1;
            $display("PASS: Error magnitude decreased from %h to %h", initial_error, error);
        end else begin
            fail_count = fail_count + 1;
            $display("FAIL: Error did not converge. Initial: %h, Current: %h", initial_error, error);
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
        $dumpvars(0,clk, d, rst, x, error, y);
    end

endmodule
