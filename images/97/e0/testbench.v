`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg Cin;
    reg Clk;
    wire Cout;
    wire Overflow;
    wire Ready;
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
        .Cout(Cout),
        .Overflow(Overflow),
        .Ready(Ready),
        .S(S)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

    begin
        A = 0;
        B = 0;
        Cin = 0;

        @(posedge Clk);
        while (Ready !== 1'b1) @(posedge Clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Test Case %0d: 2 + 3 + 0", test_num);
        A = 4'd2; B = 4'd3; Cin = 1'b0;


        while (Ready !== 1'b1) @(posedge Clk);
        @(posedge Clk);

        while (Ready !== 1'b1) @(posedge Clk);
        #1;
        #1;

        check_outputs(1'b0, 1'b0, 1'b1, 4'd5);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Test Case %0d: 5 + 2 + 1", test_num);
        A = 4'd5; B = 4'd2; Cin = 1'b1;

        while (Ready !== 1'b1) @(posedge Clk);
        @(posedge Clk);
        while (Ready !== 1'b1) @(posedge Clk);
        #1;
        #1;

        check_outputs(1'b0, 1'b0, 1'b1, 4'd8);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Test Case %0d: 7 + 1 + 0 (Positive Overflow)", test_num);
        A = 4'b0111; B = 4'b0001; Cin = 1'b0;

        while (Ready !== 1'b1) @(posedge Clk);
        @(posedge Clk);
        while (Ready !== 1'b1) @(posedge Clk);
        #1;


        #1;



        check_outputs(1'b0, 1'b1, 1'b1, 4'b1000);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Test Case %0d: 8 + 15 + 0 (-8 + -1, Negative Overflow)", test_num);
        A = 4'b1000; B = 4'b1111; Cin = 1'b0;

        while (Ready !== 1'b1) @(posedge Clk);
        @(posedge Clk);
        while (Ready !== 1'b1) @(posedge Clk);
        #1;


        #1;



        check_outputs(1'b1, 1'b1, 1'b1, 4'b0111);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Test Case %0d: 15 + 1 + 0 (-1 + 1, Carry Out No Overflow)", test_num);
        A = 4'b1111; B = 4'b0001; Cin = 1'b0;

        while (Ready !== 1'b1) @(posedge Clk);
        @(posedge Clk);
        while (Ready !== 1'b1) @(posedge Clk);
        #1;


        #1;



        check_outputs(1'b1, 1'b0, 1'b1, 4'b0000);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Test Case %0d: 15 + 15 + 1", test_num);
        A = 4'hf; B = 4'hf; Cin = 1'b1;

        while (Ready !== 1'b1) @(posedge Clk);
        @(posedge Clk);
        while (Ready !== 1'b1) @(posedge Clk);
        #1;


        #1;



        check_outputs(1'b1, 1'b0, 1'b1, 4'hf);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = 7;
        $display("Test Case %0d: 0 + 0 + 0", test_num);
        A = 4'h0; B = 4'h0; Cin = 1'b0;

        while (Ready !== 1'b1) @(posedge Clk);
        @(posedge Clk);
        while (Ready !== 1'b1) @(posedge Clk);
        #1;
        #1;

        check_outputs(1'b0, 1'b0, 1'b1, 4'h0);
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
        input expected_Overflow;
        input expected_Ready;
        input [3:0] expected_S;
        begin
            if (expected_Cout === (expected_Cout ^ Cout ^ expected_Cout) &&
                expected_Overflow === (expected_Overflow ^ Overflow ^ expected_Overflow) &&
                expected_Ready === (expected_Ready ^ Ready ^ expected_Ready) &&
                expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: Cout=%b, Overflow=%b, Ready=%b, S=%h",
                         Cout, Overflow, Ready, S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Cout=%b, Overflow=%b, Ready=%b, S=%h",
                         expected_Cout, expected_Overflow, expected_Ready, expected_S);
                $display("  Got:      Cout=%b, Overflow=%b, Ready=%b, S=%h",
                         Cout, Overflow, Ready, S);
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
        $dumpvars(0,A, B, Cin, Clk, Cout, Overflow, Ready, S);
    end

endmodule
