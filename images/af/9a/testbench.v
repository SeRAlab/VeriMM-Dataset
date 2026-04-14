`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [5:0] A;
    reg CLK;
    reg DI;
    reg [5:0] WA;
    reg WA7;
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
        .WE(WE),
        .O(O)
    );

        task reset_dut;

        begin
            A = 0;
            DI = 0;
            WA = 0;
            WA7 = 0;
            WE = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();


            WE = 1; WA7 = 1; WA = 6'd10; DI = 1'b1;
            @(posedge CLK);
            #1;


            WE = 0;
            A = 6'd10;
            #2;
            $display("Testcase %0d: Basic Write 1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();


            WE = 1; WA7 = 1; WA = 6'd20; DI = 1'b1;
            @(posedge CLK);
            #1;


            DI = 1'b0;
            @(posedge CLK);
            #1;

            WE = 0;
            A = 6'd20;
            #2;
            $display("Testcase %0d: Basic Write 0", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();


            WE = 1; WA7 = 1; WA = 6'd30; DI = 1'b0;
            @(posedge CLK);
            #1;


            WE = 0; WA7 = 1; WA = 6'd30; DI = 1'b1;
            @(posedge CLK);
            #1;

            A = 6'd30;
            #2;
            $display("Testcase %0d: WE Gating (No write when WE=0)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();


            WE = 1; WA7 = 1; WA = 6'd40; DI = 1'b0;
            @(posedge CLK);
            #1;


            WE = 1; WA7 = 0; WA = 6'd40; DI = 1'b1;
            @(posedge CLK);
            #1;

            A = 6'd40;
            #2;
            $display("Testcase %0d: WA7 Gating (No write when WA7=0)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();


            WE = 1; WA7 = 1; WA = 6'd10; DI = 1'b1;
            @(posedge CLK);
            #1;


            A = 6'd10;
            WE = 1; WA7 = 1; WA = 6'd50; DI = 1'b0;
            @(posedge CLK);
            #1;

            $display("Testcase %0d: Simultaneous Access", test_num);
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
        $dumpvars(0,A, CLK, DI, WA, WA7, WE, O);
    end

endmodule
