`timescale 1ns/1ps

module rnn_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [7:0] x;
    wire [7:0] h;
    wire [7:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rnn_cell dut (
        .clk(clk),
        .reset(reset),
        .x(x),
        .h(h),
        .y(y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        @(negedge clk);
        reset = 1;
        x = 8'h00;
        @(negedge clk);
        reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Running Test Case %0d: Initial Reset", test_num);
        reset_dut();

        #1;


        check_outputs(8'h00, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running Test Case %0d: Single Step Update", test_num);
        reset_dut();
        x = 8'h0A;
        @(negedge clk);

        #1;


        check_outputs(8'h0A, 8'h0A);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Running Test Case %0d: Multi-Step Recurrence", test_num);
        reset_dut();
        x = 8'h05; @(negedge clk);
        x = 8'h03; @(negedge clk);
        x = 8'h02; @(negedge clk);
        #1;

        check_outputs(8'h0A, 8'h0A);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running Test Case %0d: Zero Input Retention", test_num);
        reset_dut();
        x = 8'hFF; @(negedge clk);
        x = 8'h00; @(negedge clk);
        x = 8'h00; @(negedge clk);
        #1;

        check_outputs(8'hFF, 8'hFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Running Test Case %0d: Accumulation Overflow", test_num);
        reset_dut();
        x = 8'hF0; @(negedge clk);
        x = 8'h20; @(negedge clk);
        #1;

        check_outputs(8'h10, 8'h10);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Running Test Case %0d: Mid-Operation Reset", test_num);
        reset_dut();
        x = 8'h55; @(negedge clk);
        x = 8'hAA; @(negedge clk);
        reset_dut();
        #1;

        check_outputs(8'h00, 8'h00);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rnn_cell Testbench");
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
        input [7:0] expected_h;
        input [7:0] expected_y;
        begin
            if (expected_h === (expected_h ^ h ^ expected_h) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: h=%h, y=%h",
                         h, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: h=%h, y=%h",
                         expected_h, expected_y);
                $display("  Got:      h=%h, y=%h",
                         h, y);
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
        $dumpvars(0,clk, reset, x, h, y);
    end

endmodule
