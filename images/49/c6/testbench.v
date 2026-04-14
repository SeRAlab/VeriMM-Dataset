`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg Cin;
    reg Clk;
    reg Clk_180;
    reg reset;
    wire Cout;
    wire [3:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Clk(Clk),
        .Clk_180(Clk_180),
        .reset(reset),
        .Cout(Cout),
        .S(S)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            reset = 1;
            A = 0;
            B = 0;
            Cin = 0;
            @(posedge Clk);
            #1;
            reset = 0;
            @(posedge Clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Addition (2 + 3)", test_num);
            reset_dut();
            A = 4'd2;
            B = 4'd3;
            Cin = 0;
            @(posedge Clk);
            #2;
            #1;

            check_outputs(1'b0, 4'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Addition with Carry-In (5 + 5 + 1)", test_num);
            reset_dut();
            A = 4'd5;
            B = 4'd5;
            Cin = 1;
            @(posedge Clk);
            #2;
            #1;

            check_outputs(1'b0, 4'd11);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Carry-Out Overflow (8 + 8)", test_num);
            reset_dut();
            A = 4'd8;
            B = 4'd8;
            Cin = 0;
            @(posedge Clk);
            #2;
            #1;

            check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Maximum values (15 + 15 + 1)", test_num);
            reset_dut();
            A = 4'hF;
            B = 4'hF;
            Cin = 1;
            @(posedge Clk);
            #2;
            #1;

            check_outputs(1'b1, 4'hF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Zero Addition (0 + 0 + 0)", test_num);
            reset_dut();
            A = 4'd0;
            B = 4'd0;
            Cin = 0;
            @(posedge Clk);
            #2;
            #1;

            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset Functionality Check", test_num);

            A = 4'hA; B = 4'hB; Cin = 1;
            @(posedge Clk);
            #1;
            reset = 1;
            @(posedge Clk);
            #2;
            #1;

            check_outputs(1'b0, 4'h0);
            reset = 0;
        end
        endtask

    task testcases1;

        begin
            testcase001();
            testcase002();
            testcase003();
        end
        endtask

    task testcases2;

        begin
            testcase004();
            testcase005();
            testcase006();
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
        testcases1();
        testcases2();
        
        
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
        input expected_Cout;
        input [3:0] expected_S;
        begin
            if (expected_Cout === (expected_Cout ^ Cout ^ expected_Cout) &&
                expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: Cout=%b, S=%h",
                         Cout, S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Cout=%b, S=%h",
                         expected_Cout, expected_S);
                $display("  Got:      Cout=%b, S=%h",
                         Cout, S);
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
        $dumpvars(0,A, B, Cin, Clk, Clk_180, reset, Cout, S);
    end

endmodule
