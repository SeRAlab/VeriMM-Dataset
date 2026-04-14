`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg Cin;
    reg clk;
    reg rst_n;
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
        .clk(clk),
        .rst_n(rst_n),
        .Cout(Cout),
        .S(S)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            A = 0;
            B = 0;
            Cin = 0;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Checking Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Addition (4 + 5 + 0)", test_num);
            reset_dut();
            A = 4'd4;
            B = 4'd5;
            Cin = 1'b0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 4'd9);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition with Cin (7 + 2 + 1)", test_num);
            reset_dut();
            A = 4'd7;
            B = 4'd2;
            Cin = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 4'd10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max sum 15 (8 + 7 + 0)", test_num);
            reset_dut();
            A = 4'd8;
            B = 4'd7;
            Cin = 1'b0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 4'hF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Carry-out Generation (8 + 8 + 0)", test_num);
            reset_dut();
            A = 4'd8;
            B = 4'd8;
            Cin = 1'b0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Full Scale (15 + 15 + 1)", test_num);
            reset_dut();
            A = 4'hF;
            B = 4'hF;
            Cin = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 4'hF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero sum with carry (10 + 5 + 1)", test_num);
            reset_dut();
            A = 4'd10;
            B = 4'd5;
            Cin = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 4'h0);
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
        $dumpvars(0,A, B, Cin, clk, rst_n, Cout, S);
    end

endmodule
