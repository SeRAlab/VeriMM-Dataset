`timescale 1ns/1ps

module fir_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [15:0] x;
    wire [15:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fir_filter dut (
        .clk(clk),
        .reset(reset),
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
            x = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Zero Input...");
            reset_dut();
            repeat(10) begin
                x <= 16'h0000;
                @(posedge clk);
            end
            #2;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Unit Impulse...");
            reset_dut();
            x <= 16'h0001; @(posedge clk);
            repeat(7) begin
                x <= 16'h0000;
                @(posedge clk);
            end
            #2;

            #1;


            check_outputs(16'h0001);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Step Response...");
            reset_dut();
            repeat(8) begin
                x <= 16'h0001;
                @(posedge clk);
            end
            #2;
            #1;

            check_outputs(16'h0008);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Ramp Input...");
            reset_dut();
            x <= 16'd1; @(posedge clk);
            x <= 16'd2; @(posedge clk);
            x <= 16'd3; @(posedge clk);
            x <= 16'd4; @(posedge clk);
            x <= 16'd5; @(posedge clk);
            x <= 16'd6; @(posedge clk);
            x <= 16'd7; @(posedge clk);
            x <= 16'd8; @(posedge clk);
            #2;
            #1;

            check_outputs(16'd36);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Large Constant Input...");
            reset_dut();
            repeat(8) begin
                x <= 16'h1000;
                @(posedge clk);
            end
            #2;
            #1;

            check_outputs(16'h8000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fir_filter Testbench");
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
        $dumpvars(0,clk, reset, x, y);
    end

endmodule
