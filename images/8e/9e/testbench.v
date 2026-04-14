`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [5:0] A;
    reg CLK;
    reg DI;
    reg [5:0] WA;
    reg WA7;
    reg WA8;
    reg WE;
    wire O;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .CLK(CLK),
        .DI(DI),
        .WA(WA),
        .WA7(WA7),
        .WA8(WA8),
        .WE(WE),
        .O(O)
    );

        task reset_dut;

        begin
            A = 6'b0;
            DI = 1'b0;
            WA = 6'b0;
            WA7 = 1'b0;
            WA8 = 1'b0;
            WE = 1'b0;
            @(posedge CLK);
            #2;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;

            DI = 1'b1;
            WA = 6'd10;
            WA7 = 1'b1;
            WA8 = 1'b1;
            WE = 1'b1;
            @(posedge CLK);
            #2;
            WE = 1'b0;

            A = 6'd10;
            #5;
            $display("Test Case 001: Basic Write and Read");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;


            DI = 1'b0;
            WA = 6'd10;
            WA7 = 1'b1;
            WA8 = 1'b1;
            WE = 1'b1;
            @(posedge CLK);
            #2;
            WE = 1'b0;
            A = 6'd10;
            #5;
            $display("Test Case 002: Overwrite existing data");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            DI = 1'b1;
            WA = 6'd20;
            WA7 = 1'b1;
            WA8 = 1'b1;
            WE = 1'b0;
            @(posedge CLK);
            #2;
            A = 6'd20;
            #5;
            $display("Test Case 003: WE Gating");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            DI = 1'b1;
            WA = 6'd30;
            WA7 = 1'b0;
            WA8 = 1'b1;
            WE = 1'b1;
            @(posedge CLK);
            #2;
            A = 6'd30;
            #5;
            $display("Test Case 004: WA7 Gating");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            DI = 1'b1;
            WA = 6'd40;
            WA7 = 1'b1;
            WA8 = 1'b0;
            WE = 1'b1;
            @(posedge CLK);
            #2;
            A = 6'd40;
            #5;
            $display("Test Case 005: WA8 Gating");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;

            DI = 1'b1;
            WA = 6'd50;
            WA7 = 1'b1;
            WA8 = 1'b1;
            WE = 1'b1;
            @(posedge CLK);
            #2;
            WE = 1'b0;

            A = 6'd5;
            #2;
            if (O === 1'b0) begin
                 A = 6'd50;
                 #5;
                 $display("Test Case 006: Independent Dual Port Access");
                 #1;

                 check_outputs(1'b1);
            end else begin
                 $display("Test Case 006: Failed initial read");
                 fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            DI = 1'b1;
            WA = 6'd63;
            WA7 = 1'b1;
            WA8 = 1'b1;
            WE = 1'b1;
            @(posedge CLK);
            #2;
            WE = 1'b0;
            A = 6'd63;
            #5;
            $display("Test Case 007: Boundary Address 63");
            #1;

            check_outputs(1'b1);
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
        input expected_O;
        begin
            if (expected_O === (expected_O ^ O ^ expected_O)) begin
                $display("PASS");
                $display("  Outputs: O=%b",
                         O);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O=%b",
                         expected_O);
                $display("  Got:      O=%b",
                         O);
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
        $dumpvars(0,A, CLK, DI, WA, WA7, WA8, WE, O);
    end

endmodule
