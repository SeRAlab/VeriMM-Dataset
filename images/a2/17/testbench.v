`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg start;
    wire [7:0] a;
    wire [7:0] b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .start(start),
        .a(a),
        .b(b)
    );

    // Clock generation (10ns period)
    initial begin
        start = 0;
        forever #5 start = ~start;
    end

        task reset_dut;

        begin
            A = 8'h00;
            B = 8'h00;


            @(negedge start);
            #(1);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Swap (0x12, 0x34)", test_num);
            reset_dut();
            A = 8'h12;
            B = 8'h34;

            @(posedge start);
            #2;

            #1;


            check_outputs(8'h34, 8'h12);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Swap with Zero and Max values (0x00, 0xFF)", test_num);
            reset_dut();
            A = 8'h00;
            B = 8'hFF;
            @(posedge start);
            #2;
            #1;

            check_outputs(8'hFF, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Identical values (0x55, 0x55)", test_num);
            reset_dut();
            A = 8'h55;
            B = 8'h55;
            @(posedge start);
            #2;
            #1;

            check_outputs(8'h55, 8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating bits (0xAA, 0x55)", test_num);
            reset_dut();
            A = 8'hAA;
            B = 8'h55;
            @(posedge start);
            #2;
            #1;

            check_outputs(8'h55, 8'hAA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Random pattern (0xDE, 0xAD)", test_num);
            reset_dut();
            A = 8'hDE;
            B = 8'hAD;
            @(posedge start);
            #2;
            #1;

            check_outputs(8'hAD, 8'hDE);
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
        input [7:0] expected_a;
        input [7:0] expected_b;
        begin
            if (expected_a === (expected_a ^ a ^ expected_a) &&
                expected_b === (expected_b ^ b ^ expected_b)) begin
                $display("PASS");
                $display("  Outputs: a=%h, b=%h",
                         a, b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a=%h, b=%h",
                         expected_a, expected_b);
                $display("  Got:      a=%h, b=%h",
                         a, b);
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
        $dumpvars(0,A, B, start, a, b);
    end

endmodule
