`timescale 1ns/1ps

module iir_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [15:0] x;
    wire [15:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    iir_filter dut (
        .clk(clk),
        .rst(rst),
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
            rst = 1;
            x = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Zero Input");
            test_num = test_num + 1;
            reset_dut();
            x = 16'h0000;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Impulse Response");
            test_num = test_num + 1;
            reset_dut();
            x = 16'h0001; @(posedge clk);
            x = 16'h0000;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: DC Step Response");
            test_num = test_num + 1;
            reset_dut();
            x = 16'h000A;
            repeat(20) @(posedge clk);

            #1;


            check_outputs(16'h000A);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Negative Values");
            test_num = test_num + 1;
            reset_dut();
            x = 16'hFFFE;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(16'hFFFE);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Full Scale Transition");
            test_num = test_num + 1;
            reset_dut();
            x = 16'h7FFF;
            @(posedge clk);
            x = 16'h8000;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(16'h8000);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning Testcase 006: Alternating Input");
            test_num = test_num + 1;
            reset_dut();
            repeat(5) begin
                x = 16'h00FF; @(posedge clk);
                x = 16'hFF00; @(posedge clk);
            end
            #1;

            check_outputs(16'hFF00);
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
        $dumpvars(0,clk, rst, x, y);
    end

endmodule
