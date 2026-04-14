`timescale 1ns/1ps

module iir_filter_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] a1;
    reg [15:0] a2;
    reg [15:0] b0;
    reg [15:0] b1;
    reg [15:0] b2;
    reg clk;
    reg reset;
    reg [15:0] x;
    wire [15:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    iir_filter dut (
        .a1(a1),
        .a2(a2),
        .b0(b0),
        .b1(b1),
        .b2(b2),
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
            a1 = 0; a2 = 0; b0 = 0; b1 = 0; b2 = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: All Zeros...");
            reset_dut();
            a1 = 0; a2 = 0; b0 = 0; b1 = 0; b2 = 0;
            x = 16'hFFFF;
            @(posedge clk);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Identity Pass-through...");
            reset_dut();
            a1 = 0; a2 = 0; b0 = 16'h0001; b1 = 0; b2 = 0;
            x = 16'h00A5;
            @(posedge clk);
            #1;

            check_outputs(16'h00A5);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Unit Delay...");
            reset_dut();
            a1 = 0; a2 = 0; b0 = 0; b1 = 16'h0001; b2 = 0;
            x = 16'h1234;
            @(posedge clk);
            x = 16'h0000;
            @(posedge clk);

            #1;


            check_outputs(16'h1234);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: FIR Mode Summation...");
            reset_dut();
            a1 = 0; a2 = 0; b0 = 1; b1 = 1; b2 = 1;
            x = 16'h0002; @(posedge clk);
            x = 16'h0003; @(posedge clk);
            x = 16'h0004; @(posedge clk);
            #1;

            check_outputs(16'h0009);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Recursive Accumulator...");
            reset_dut();
            a1 = 16'hFFFF;
            a2 = 0;
            b0 = 1; b1 = 0; b2 = 0;
            x = 16'h0005; @(posedge clk);
            x = 16'h0005; @(posedge clk);
            x = 16'h0005; @(posedge clk);
            #1;

            check_outputs(16'h000F);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Complex Direct Form II...");
            reset_dut();
            a1 = 16'h0001; a2 = 0;
            b0 = 16'h0002; b1 = 16'h0001; b2 = 0;
            x = 16'h000A; @(posedge clk);
            x = 16'h0005; @(posedge clk);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Second Order Delay...");
            reset_dut();
            a1 = 0; a2 = 0; b0 = 0; b1 = 0; b2 = 16'h0001;
            x = 16'hBEEF; @(posedge clk);
            x = 16'h0000; @(posedge clk);
            x = 16'h0000; @(posedge clk);
            #1;

            check_outputs(16'hBEEF);
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
        $dumpvars(0,a1, a2, b0, b1, b2, clk, reset, x, y);
    end

endmodule
