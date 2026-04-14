`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ctrl;
    reg [3:0] data;
    wire [3:0] corrected;
    wire [6:0] hamming;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ctrl(ctrl),
        .data(data),
        .corrected(corrected),
        .hamming(hamming)
    );

    // Clock generation (10ns period)
    initial begin
        ctrl = 0;
        forever #5 ctrl = ~ctrl;
    end

        task reset_dut;

    begin
        data = 4'b0000;

        @(posedge ctrl);
        @(negedge ctrl);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Zeros (4'b0000)", test_num);
        reset_dut();
        data = 4'b0000;
        @(posedge ctrl);
        #2;
        @(negedge ctrl);
        #2;
        #1;

        check_outputs(4'b0000, 7'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Ones (4'b1111)", test_num);
        reset_dut();
        data = 4'b1111;
        @(posedge ctrl);
        #2;
        @(negedge ctrl);
        #2;
        #1;

        check_outputs(4'b1111, 7'h7F);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Pattern 1010", test_num);
        reset_dut();
        data = 4'b1010;
        @(posedge ctrl);
        #2;
        @(negedge ctrl);
        #2;

        #1;


        check_outputs(4'b1010, 7'h2D);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Pattern 0101", test_num);
        reset_dut();
        data = 4'b0101;
        @(posedge ctrl);
        #2;
        @(negedge ctrl);
        #2;

        #1;


        check_outputs(4'b0101, 7'h52);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Pattern 1100", test_num);
        reset_dut();
        data = 4'b1100;
        @(posedge ctrl);
        #2;
        @(negedge ctrl);
        #2;

        #1;


        check_outputs(4'b1100, 7'h1E);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Pattern 0011", test_num);
        reset_dut();
        data = 4'b0011;
        @(posedge ctrl);
        #2;
        @(negedge ctrl);
        #2;

        #1;


        check_outputs(4'b0011, 7'h61);
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
        input [3:0] expected_corrected;
        input [6:0] expected_hamming;
        begin
            if (expected_corrected === (expected_corrected ^ corrected ^ expected_corrected) &&
                expected_hamming === (expected_hamming ^ hamming ^ expected_hamming)) begin
                $display("PASS");
                $display("  Outputs: corrected=%h, hamming=%h",
                         corrected, hamming);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: corrected=%h, hamming=%h",
                         expected_corrected, expected_hamming);
                $display("  Got:      corrected=%h, hamming=%h",
                         corrected, hamming);
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
        $dumpvars(0,ctrl, data, corrected, hamming);
    end

endmodule
