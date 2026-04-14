`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [15:0] D;
    reg DIR;
    reg LOAD;
    reg RESET;
    reg [15:0] V;
    wire [15:0] Q;
    wire [3:0] R;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .D(D),
        .DIR(DIR),
        .LOAD(LOAD),
        .RESET(RESET),
        .V(V),
        .Q(Q),
        .R(R)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RESET = 1;
            LOAD = 0;
            DIR = 0;
            D = 0;
            V = 1;
            @(posedge CLK);
            #1;
            RESET = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Reset Verification");
            reset_dut();


            #1;



            check_outputs(16'h0000, 4'h0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Load and Division");
            reset_dut();
            D = 16'd100;
            V = 16'd7;
            LOAD = 1;
            DIR = 1;
            @(posedge CLK);
            #1;


            #1;



            check_outputs(16'd114, 4'h2);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Increment (Up Count)");
            reset_dut();

            D = 16'd50;
            V = 16'd10;
            LOAD = 1;
            @(posedge CLK);
            #1;

            LOAD = 0;
            DIR = 1;
            @(posedge CLK);
            #1;


            #1;



            check_outputs(16'd56, 4'h0);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Decrement (Down Count)");
            reset_dut();

            D = 16'd20;
            V = 16'd3;
            LOAD = 1;
            @(posedge CLK);
            #1;

            LOAD = 0;
            DIR = 0;
            @(posedge CLK);
            #1;


            #1;



            check_outputs(16'd25, 4'h2);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Large values and Remainder Masking");
            reset_dut();

            D = 16'hF000;
            V = 16'h0100;
            LOAD = 1;
            @(posedge CLK);
            #1;


            #1;



            check_outputs(16'hF0F0, 4'h0);


            D = 16'd1035;
            V = 16'd32;
            LOAD = 1;
            @(posedge CLK);
            #1;


            #1;



            check_outputs(16'd1067, 4'hB);
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
        input [15:0] expected_Q;
        input [3:0] expected_R;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_R === (expected_R ^ R ^ expected_R)) begin
                $display("PASS");
                $display("  Outputs: Q=%h, R=%h",
                         Q, R);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h, R=%h",
                         expected_Q, expected_R);
                $display("  Got:      Q=%h, R=%h",
                         Q, R);
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
        $dumpvars(0,CLK, D, DIR, LOAD, RESET, V, Q, R);
    end

endmodule
