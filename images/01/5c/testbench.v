`timescale 1ns/1ps

module iir_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [15:0] x_in;
    wire [15:0] y_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    iir_filter dut (
        .clk(clk),
        .reset(reset),
        .x_in(x_in),
        .y_out(y_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            x_in = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Test Case 001: Unit Impulse (Initial Sample)");
            test_num = test_num + 1;
            reset_dut();
            x_in <= 16'd10000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h07D0);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Impulse Response Sequence (3 cycles)");
            test_num = test_num + 1;
            reset_dut();
            x_in <= 16'd10000;
            @(posedge clk);
            x_in <= 16'd0;
            @(posedge clk);
            x_in <= 16'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h18B0);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Step Response (3 cycles)");
            test_num = test_num + 1;
            reset_dut();
            x_in <= 16'd5000;
            @(posedge clk);
            x_in <= 16'd5000;
            @(posedge clk);
            x_in <= 16'd5000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h17AC);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Negative Input Sequence");
            test_num = test_num + 1;
            reset_dut();
            x_in <= -16'd1000;
            @(posedge clk);
            x_in <= -16'd1000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFDBC);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Zero Input Decay");
            test_num = test_num + 1;
            reset_dut();
            x_in <= 16'd10000;
            @(posedge clk);
            x_in <= 16'd0;
            @(posedge clk);
            x_in <= 16'd0;
            @(posedge clk);
            x_in <= 16'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0864);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("iir_filter Testbench");
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
        input [15:0] expected_y_out;
        begin
            if (expected_y_out === (expected_y_out ^ y_out ^ expected_y_out)) begin
                $display("PASS");
                $display("  Outputs: y_out=%h",
                         y_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y_out=%h",
                         expected_y_out);
                $display("  Got:      y_out=%h",
                         y_out);
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
        $dumpvars(0,clk, reset, x_in, y_out);
    end

endmodule
