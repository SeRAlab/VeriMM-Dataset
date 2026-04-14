`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [3:0] D;
    reg EN;
    reg LOAD;
    reg RST;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .D(D),
        .EN(EN),
        .LOAD(LOAD),
        .RST(RST),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            EN = 0;
            LOAD = 0;
            D = 0;
            @(posedge CLK);
            #1 RST = 0;
            @(posedge CLK);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Synchronous Reset");
            reset_dut();

            #1;


            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Basic Increment (3 cycles)");
            reset_dut();
            @(negedge CLK);
            EN = 1;
            LOAD = 0;
            repeat (3) @(posedge CLK);
            #1 #1;
 check_outputs(4'h3);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Load functionality");
            reset_dut();
            @(negedge CLK);
            EN = 1;
            LOAD = 1;
            D = 4'hA;
            @(posedge CLK);
            #1 #1;
 check_outputs(4'hA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Enable/Hold functionality");
            reset_dut();
            @(negedge CLK);
            EN = 1;
            LOAD = 0;
            repeat (2) @(posedge CLK);
            @(negedge CLK);
            EN = 0;
            repeat (2) @(posedge CLK);
            #1 #1;
 check_outputs(4'h2);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Roll-over (15 to 0)");
            reset_dut();
            @(negedge CLK);
            EN = 1;
            LOAD = 1;
            D = 4'hF;
            @(posedge CLK);
            @(negedge CLK);
            LOAD = 0;
            @(posedge CLK);
            #1 #1;
 check_outputs(4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Priority Check (Reset vs Load)");
            reset_dut();
            @(negedge CLK);
            EN = 1;
            LOAD = 1;
            D = 4'h5;
            RST = 1;
            @(posedge CLK);
            #1 #1;
 check_outputs(4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Priority Check (Load vs Increment)");
            reset_dut();
            @(negedge CLK);
            EN = 1;
            LOAD = 1;
            D = 4'h7;
            @(posedge CLK);
            #1 #1;
 check_outputs(4'h7);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case 008: Complex Sequence");
            reset_dut();
            @(negedge CLK);
            EN = 1;
            LOAD = 1;
            D = 4'hC;
            @(posedge CLK);
            @(negedge CLK);
            LOAD = 0;
            @(posedge CLK);
            @(negedge CLK);
            EN = 0;
            @(posedge CLK);
            @(negedge CLK);
            EN = 1;
            @(posedge CLK);
            #1 #1;
 check_outputs(4'hE);
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
        testcase007();
        testcase008();
        
        
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
        $dumpvars(0,CLK, D, EN, LOAD, RST, Q);
    end

endmodule
