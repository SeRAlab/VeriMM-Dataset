`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [3:0] DATA;
    reg LOAD;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .DATA(DATA),
        .LOAD(LOAD),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            LOAD = 1;
            DATA = 4'b0000;
            @(posedge CLK);
            #1;
            LOAD = 0;
            DATA = 4'b0000;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Load", test_num);
            reset_dut();
            LOAD = 1;
            DATA = 4'b1010;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Shift Left", test_num);
            reset_dut();

            LOAD = 1;
            DATA = 4'b1011;
            @(posedge CLK);
            #1;

            LOAD = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Double Shift Left", test_num);
            reset_dut();

            LOAD = 1;
            DATA = 4'b0111;
            @(posedge CLK);
            #1;

            LOAD = 0;
            @(posedge CLK);
            #1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Full Shift Out", test_num);
            reset_dut();

            LOAD = 1;
            DATA = 4'b1000;
            @(posedge CLK);
            #1;

            LOAD = 0;
            repeat(3) @(posedge CLK);
            #1;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load Priority", test_num);
            reset_dut();
            LOAD = 1;
            DATA = 4'b1111;
            @(posedge CLK);
            #1;
            DATA = 4'b0101;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift 4 times (All Zeros)", test_num);
            reset_dut();
            LOAD = 1;
            DATA = 4'b1111;
            @(posedge CLK);
            #1;
            LOAD = 0;
            repeat(4) @(posedge CLK);
            #1;
            #1;

            check_outputs(4'b0000);
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
        input [3:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,CLK, DATA, LOAD, Q);
    end

endmodule
