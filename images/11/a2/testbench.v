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
            x_in = 16'd0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Reset Verification");
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Zero Input Response");
            reset_dut();
            x_in = 16'h0000;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Impulse Response (t=0)");
            reset_dut();
            x_in = 16'h00FF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h00FF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Impulse Response (t=2)");
            reset_dut();
            x_in = 16'h0100;
            @(posedge clk);
            x_in = 16'h0000;
            @(posedge clk);
            @(posedge clk);
            #1;


            #1;



            check_outputs(16'h0040);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: DC Step Response");
            reset_dut();
            x_in = 16'h0010;
            repeat(10) @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0020);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Negative Input Test");
            reset_dut();
            x_in = 16'hFF00;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hFF00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Max Positive Input");
            reset_dut();
            x_in = 16'h7FFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h7FFF);
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
        testcase006();
        testcase007();
        
        
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
