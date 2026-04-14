`timescale 1ns/1ps

module fir_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] x_in;
    wire [15:0] y_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fir_filter dut (
        .clk(clk),
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
            rst_n = 0;
            x_in = 0;
            repeat(2) @(posedge clk);
            #1;
            rst_n = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %03d: Zero Input", test_num);
            reset_dut();
            x_in = 16'h0000;
            repeat(32) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %03d: Impulse Response (h[0])", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            x_in = 16'h0005;
            @(posedge clk);
            #1;
            x_in = 16'h0000;
            #1;

            check_outputs(16'h0005);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %03d: Step Response (DC Gain)", test_num);
            reset_dut();
            repeat(32) begin
                @(posedge clk);
                #1;
                x_in = 16'h0001;
            end
            #1;

            check_outputs(16'h0020);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %03d: Impulse Propagation (h[31])", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            x_in = 16'h000A;
            @(posedge clk);
            #1;
            x_in = 16'h0000;
            repeat(30) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h000A);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %03d: Large Input Scaling", test_num);
            reset_dut();
            repeat(32) begin
                @(posedge clk);
                #1;
                x_in = 16'd100;
            end
            #1;

            check_outputs(16'h0C80);
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
        $dumpvars(0,clk, x_in, y_out);
    end

endmodule
