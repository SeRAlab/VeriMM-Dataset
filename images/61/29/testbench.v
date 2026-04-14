`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg Cin;
    reg [1:0] Sel;
    reg clk;
    wire Cout;
    wire [3:0] Sum;
    wire [3:0] Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Sel(Sel),
        .clk(clk),
        .Cout(Cout),
        .Sum(Sum),
        .Z(Z)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A = 4'b0;
            B = 4'b0;
            Cin = 1'b0;
            Sel = 2'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Addition 5 + 3, Cin=0", test_num);
            A = 4'd5;
            B = 4'd3;
            Cin = 1'b0;
            Sel = 2'b00;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 4'd8, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Addition 7 + 2, Cin=1", test_num);
            A = 4'd7;
            B = 4'd2;
            Cin = 1'b1;
            Sel = 2'b00;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 4'hA, 4'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Addition 15 + 1, Cin=0 (Overflow)", test_num);
            A = 4'd15;
            B = 4'd1;
            Cin = 1'b0;
            Sel = 2'b00;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 4'd0, 4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Subtraction 10 - 4, Cin=0", test_num);
            A = 4'd10;
            B = 4'd4;
            Cin = 1'b0;
            Sel = 2'b01;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 4'd6, 4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Subtraction 4 - 5, Cin=0 (Borrow)", test_num);
            A = 4'd4;
            B = 4'd5;
            Cin = 1'b0;
            Sel = 2'b01;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 4'd15, 4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Bitwise AND 1010 & 1100", test_num);
            A = 4'b1010;
            B = 4'b1100;
            Sel = 2'b10;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 4'd0, 4'b1000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Bitwise OR 1010 | 1100", test_num);
            A = 4'b1010;
            B = 4'b1100;
            Sel = 2'b11;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 4'd0, 4'b1110);
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
        input [3:0] expected_Sum;
        input [3:0] expected_Z;
        begin
            if (expected_Cout === (expected_Cout ^ Cout ^ expected_Cout) &&
                expected_Sum === (expected_Sum ^ Sum ^ expected_Sum) &&
                expected_Z === (expected_Z ^ Z ^ expected_Z)) begin
                $display("PASS");
                $display("  Outputs: Cout=%b, Sum=%h, Z=%h",
                         Cout, Sum, Z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Cout=%b, Sum=%h, Z=%h",
                         expected_Cout, expected_Sum, expected_Z);
                $display("  Got:      Cout=%b, Sum=%h, Z=%h",
                         Cout, Sum, Z);
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
        $dumpvars(0,A, B, Cin, Sel, clk, Cout, Sum, Z);
    end

endmodule
