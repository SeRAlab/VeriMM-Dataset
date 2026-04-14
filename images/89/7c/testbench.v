`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg E;
    reg [5:0] I1;
    reg I2;
    reg I3;
    reg Q;
    reg clk;
    reg p_18_out;
    wire O1;
    wire O2;
    wire [5:0] O3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .E(E),
        .I1(I1),
        .I2(I2),
        .I3(I3),
        .Q(Q),
        .clk(clk),
        .p_18_out(p_18_out),
        .O1(O1),
        .O2(O2),
        .O3(O3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            E = 0;
            Q = 0;
            I1 = 0;
            I2 = 1;
            I3 = 0;
            p_18_out = 0;
            repeat(2) @(posedge clk);
            #1 I2 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Initial State Check");
            reset_dut();

            #1;


            check_outputs(1'b1, 1'b0, 6'bx);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Single Write and Read");
            reset_dut();


            I1 = 6'h2A;
            E = 1;
            @(posedge clk);
            #1 E = 0;


            Q = 1;
            @(posedge clk);
            #1 Q = 0;


            #1;



            check_outputs(1'b1, 1'b0, 6'h2A);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Fill FIFO Check");
            reset_dut();

            E = 1;
            I1 = 6'h01; @(posedge clk);
            I1 = 6'h02; @(posedge clk);
            I1 = 6'h03; @(posedge clk);
            I1 = 6'h04; @(posedge clk);
            #1 E = 0;


            #1;



            check_outputs(1'b0, 1'b1, 6'bx);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Multi-word Data Integrity");
            reset_dut();


            E = 1; I1 = 6'h10; @(posedge clk);
            I1 = 6'h11; @(posedge clk);
            #1 E = 0;


            Q = 1; @(posedge clk);
            #1 Q = 0;


            E = 1; I1 = 6'h12; @(posedge clk);
            #1 E = 0;


            Q = 1; @(posedge clk);
            @(posedge clk);
            #1 Q = 0;


            #1;



            check_outputs(1'b1, 1'b0, 6'h12);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input expected_O1;
        input expected_O2;
        input [5:0] expected_O3;
        begin
            if (expected_O1 === (expected_O1 ^ O1 ^ expected_O1) &&
                expected_O2 === (expected_O2 ^ O2 ^ expected_O2) &&
                expected_O3 === (expected_O3 ^ O3 ^ expected_O3)) begin
                $display("PASS");
                $display("  Outputs: O1=%b, O2=%b, O3=%h",
                         O1, O2, O3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O1=%b, O2=%b, O3=%h",
                         expected_O1, expected_O2, expected_O3);
                $display("  Got:      O1=%b, O2=%b, O3=%h",
                         O1, O2, O3);
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
        $dumpvars(0,E, I1, I2, I3, Q, clk, p_18_out, O1, O2, O3);
    end

endmodule
