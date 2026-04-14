`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg Cin;
    wire Cout;
    wire [15:0] Sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Cout(Cout),
        .Sum(Sum)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: All Zeros", test_num);
        A = 16'h0000; B = 16'h0000; Cin = 1'b0;
        #1;

        check_outputs(1'b0, 16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Simple Addition without Carry", test_num);
        A = 16'h1234; B = 16'h4321; Cin = 1'b0;
        #1;

        check_outputs(1'b0, 16'h5555);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Simple Addition with Cin", test_num);
        A = 16'h1111; B = 16'h2222; Cin = 1'b1;
        #1;

        check_outputs(1'b0, 16'h3334);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Boundary - Max A and B", test_num);
        A = 16'hFFFF; B = 16'hFFFF; Cin = 1'b0;
        #1;

        check_outputs(1'b1, 16'hFFFE);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Boundary - Max values with Cin", test_num);
        A = 16'hFFFF; B = 16'hFFFF; Cin = 1'b1;
        #1;

        check_outputs(1'b1, 16'hFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Carry Propagation through all bits (0xFFFF + 1)", test_num);
        A = 16'hFFFF; B = 16'h0001; Cin = 1'b0;
        #1;

        check_outputs(1'b1, 16'h0000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Carry Out check (0x8000 + 0x8000)", test_num);
        A = 16'h8000; B = 16'h8000; Cin = 1'b0;
        #1;

        check_outputs(1'b1, 16'h0000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Interleaved Bits (0xAAAA + 0x5555)", test_num);
        A = 16'hAAAA; B = 16'h5555; Cin = 1'b0;
        #1;

        check_outputs(1'b0, 16'hFFFF);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Interleaved Bits with Cin (0xAAAA + 0x5555 + 1)", test_num);
        A = 16'hAAAA; B = 16'h5555; Cin = 1'b1;
        #1;

        check_outputs(1'b1, 16'h0000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Random Addition", test_num);
        A = 16'hA5A5; B = 16'h5A5A; Cin = 1'b0;
        #1;

        check_outputs(1'b0, 16'hFFFF);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Testcase %0d: Cin propagation through empty sum", test_num);
        A = 16'h0000; B = 16'h0000; Cin = 1'b1;
        #1;

        check_outputs(1'b0, 16'h0001);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Testcase %0d: MSB addition check", test_num);
        A = 16'h4000; B = 16'h4000; Cin = 1'b0;
        #1;

        check_outputs(1'b0, 16'h8000);
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
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        
        
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
        input [15:0] expected_Sum;
        begin
            #1; // Small delay for combinational logic to settle
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

endmodule
