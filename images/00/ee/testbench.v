`timescale 1ns/1ps

module adaptive_lms_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] d;
    reg reset;
    reg update;
    reg [15:0] x;
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
        .update(update),
        .x(x),
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
            d = 16'h0000;
            x = 16'h0000;
            update = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase001: Reset Verification");
            reset_dut();

            reset = 1;
            x = 16'hFFFF;
            d = 16'hFFFF;
            update = 1;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase002: No Update Operation");
            reset_dut();
            x = 16'h1234;
            d = 16'h5678;
            update = 0;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase003: Zero Input Signal");
            reset_dut();
            x = 16'h0000;
            d = 16'h7FFF;
            update = 1;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        reg [15:0] last_y;
        begin
            test_num = 4;
            $display("Testcase004: Basic Adaptation Check");
            reset_dut();
            x = 16'h0100;
            d = 16'h0500;
            update = 1;
            repeat(10) @(posedge clk);


            if (y != 16'h0000) begin
                pass_count = pass_count + 1;
                $display("PASS: Filter adapted, y=%h", y);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Filter failed to adapt, y remains zero");
            end
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase005: Convergence Trend Check");
            reset_dut();
            x = 16'h0001;
            d = 16'h0010;
            update = 1;
            repeat(100) @(posedge clk);


            if (y > 16'h0000) begin
                pass_count = pass_count + 1;
                $display("PASS: Output converged to positive value y=%h", y);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: No convergence detected");
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
        input [15:0] expected_y;
        begin
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
        $dumpvars(0,clk, d, reset, update, x, y);
    end

endmodule
