`timescale 1ns/1ps

module lms_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] d;
    reg reset;
    reg [15:0] x;
    wire [15:0] w;
    wire [15:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lms_filter dut (
        .clk(clk),
        .d(d),
        .reset(reset),
        .x(x),
        .w(w),
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
            d = 0;
            x = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset Verification");
            reset_dut();

            #1;


            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Zero Input Test");
            reset_dut();
            x = 16'h0000;
            d = 16'h1000;
            repeat (10) @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase003;

        reg [15:0] prev_w;
        begin
            $display("Testcase 003: Weight Update Direction");
            reset_dut();
            prev_w = w;
            x = 16'h0100;
            d = 16'h2000;
            @(posedge clk);
            #1;


            if (w > prev_w) begin
                $display("PASS: Weight increased as expected.");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Weight did not increase. w=%h", w);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Testcase 004: Convergence Test");
            reset_dut();


            x = 16'h4000;
            d = 16'h2000;

            repeat (100) @(posedge clk);

            #1;




            if (y >= 16'h1F00 && y <= 16'h2100) begin
                $display("PASS: Converged to desired output range.");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Did not converge. y=%h, expected approx %h", y, d);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Negative Input Test");
            reset_dut();
            x = 16'hFF00;
            d = 16'h0100;


            repeat (5) @(posedge clk);
            #1;
            if (w[15] == 1'b1) begin
                $display("PASS: Weight adjusted correctly for negative input.");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Weight sign bit incorrect. w=%h", w);
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
        $display("lms_filter Testbench");
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
        input [15:0] expected_w;
        input [15:0] expected_y;
        begin
            if (expected_w === (expected_w ^ w ^ expected_w) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: w=%h, y=%h",
                         w, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: w=%h, y=%h",
                         expected_w, expected_y);
                $display("  Got:      w=%h, y=%h",
                         w, y);
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
        $dumpvars(0,clk, d, reset, x, w, y);
    end

endmodule
