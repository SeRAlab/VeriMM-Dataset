`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg A;
    reg B;
    reg Cin;
    reg Clk;
    reg En;
    reg Rst;
    wire Cout;
    wire [3:0] Sum;

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
        .En(En),
        .Rst(Rst),
        .Cout(Cout),
        .Sum(Sum)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

    begin
        Rst = 1;
        En = 0;
        A = 0;
        B = 0;
        Cin = 0;
        @(posedge Clk);
        #1;
        Rst = 0;
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        A = 4'h2;
        B = 4'h3;
        Cin = 0;
        En = 1;
        @(posedge Clk);
        #1;
        #1;

        check_outputs(0, 4'h5);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        A = 4'h5;
        B = 4'h2;
        Cin = 1;
        En = 1;
        @(posedge Clk);
        #1;
        #1;

        check_outputs(0, 4'h8);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        A = 4'hF;
        B = 4'h1;
        Cin = 0;
        En = 1;
        @(posedge Clk);
        #1;
        #1;

        check_outputs(1, 4'h0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        A = 4'h8;
        B = 4'h7;
        Cin = 1;
        En = 1;
        @(posedge Clk);
        #1;
        #1;

        check_outputs(1, 4'h0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();

        A = 4'hA;
        B = 4'h2;
        Cin = 0;
        En = 0;
        @(posedge Clk);
        #1;

        if (Sum == 4'h0 && Cout == 0) begin

            En = 1;
            @(posedge Clk);
            #1;
            #1;

            check_outputs(0, 4'hC);
        end else begin
            $display("Test %0d: FAIL (Enable logic initialization)", test_num + 1);
            fail_count = fail_count + 1;
            test_num = test_num + 1;
        end
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        A = 4'hF;
        B = 4'hF;
        Cin = 1;
        En = 1;
        @(posedge Clk);
        #1;
        #1;

        check_outputs(1, 4'hF);
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
        input expected_Cout;
        input [3:0] expected_Sum;
        begin
            if (expected_Cout === (expected_Cout ^ Cout ^ expected_Cout) &&
                expected_Sum === (expected_Sum ^ Sum ^ expected_Sum)) begin
                $display("PASS");
                $display("  Outputs: Cout=%b, Sum=%h",
                         Cout, Sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Cout=%b, Sum=%h",
                         expected_Cout, expected_Sum);
                $display("  Got:      Cout=%b, Sum=%h",
                         Cout, Sum);
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
        $dumpvars(0,A, B, Cin, Clk, En, Rst, Cout, Sum);
    end

endmodule
