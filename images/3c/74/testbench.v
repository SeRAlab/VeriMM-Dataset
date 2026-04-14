`timescale 1ns/1ps

module backpropagation_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] T;
    reg [3:0] X0;
    reg [3:0] X1;
    reg [3:0] X2;
    reg [3:0] X3;
    reg [3:0] X4;
    reg clk;
    reg reset;
    wire [3:0] W0;
    wire [3:0] W1;
    wire [3:0] W2;
    wire [3:0] W3;
    wire [3:0] W4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    backpropagation dut (
        .T(T),
        .X0(X0),
        .X1(X1),
        .X2(X2),
        .X3(X3),
        .X4(X4),
        .clk(clk),
        .reset(reset),
        .W0(W0),
        .W1(W1),
        .W2(W2),
        .W3(W3),
        .W4(W4)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            T = 0; X0 = 0; X1 = 0; X2 = 0; X3 = 0; X4 = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Test Case 001: All Zeros");
            reset_dut();
            T = 0; X0 = 0; X1 = 0; X2 = 0; X3 = 0; X4 = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(4'h0, 4'h0, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Single Input Update X0");
            reset_dut();
            T = 4'h1; X0 = 4'h5; X1 = 0; X2 = 0; X3 = 0; X4 = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(4'h5, 4'h0, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Single Input Update X2");
            reset_dut();
            T = 4'h3; X0 = 0; X1 = 0; X2 = 4'h2; X3 = 0; X4 = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(4'h0, 4'h0, 4'h6, 4'h0, 4'h0);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Multiple Input Updates");
            reset_dut();
            T = 4'h2; X0 = 4'h1; X1 = 4'h2; X2 = 4'h3; X3 = 4'h4; X4 = 4'h0;
            @(posedge clk);
            #1 #1;
 check_outputs(4'h2, 4'h4, 4'h6, 4'h8, 4'h0);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Boundary Value Check");
            reset_dut();
            T = 4'h1; X0 = 4'hF; X1 = 4'h0; X2 = 4'h0; X3 = 4'h0; X4 = 4'h0;
            @(posedge clk);
            #1 #1;
 check_outputs(4'hF, 4'h0, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Overflow Wrapping Check");
            reset_dut();
            T = 4'h4; X0 = 4'h4; X1 = 0; X2 = 0; X3 = 0; X4 = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(4'h0, 4'h0, 4'h0, 4'h0, 4'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("backpropagation Testbench");
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
        input [3:0] expected_W0;
        input [3:0] expected_W1;
        input [3:0] expected_W2;
        input [3:0] expected_W3;
        input [3:0] expected_W4;
        begin
            if (expected_W0 === (expected_W0 ^ W0 ^ expected_W0) &&
                expected_W1 === (expected_W1 ^ W1 ^ expected_W1) &&
                expected_W2 === (expected_W2 ^ W2 ^ expected_W2) &&
                expected_W3 === (expected_W3 ^ W3 ^ expected_W3) &&
                expected_W4 === (expected_W4 ^ W4 ^ expected_W4)) begin
                $display("PASS");
                $display("  Outputs: W0=%h, W1=%h, W2=%h, W3=%h, W4=%h",
                         W0, W1, W2, W3, W4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: W0=%h, W1=%h, W2=%h, W3=%h, W4=%h",
                         expected_W0, expected_W1, expected_W2, expected_W3, expected_W4);
                $display("  Got:      W0=%h, W1=%h, W2=%h, W3=%h, W4=%h",
                         W0, W1, W2, W3, W4);
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
        $dumpvars(0,T, X0, X1, X2, X3, X4, clk, reset, W0, W1, W2, W3, W4);
    end

endmodule
