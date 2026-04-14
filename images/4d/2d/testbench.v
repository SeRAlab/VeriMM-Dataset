`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Add_Sub;
    reg Cin;
    reg [31:0] DataA;
    reg [31:0] DataB;
    wire Cout;
    wire [31:0] Result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Add_Sub(Add_Sub),
        .Cin(Cin),
        .DataA(DataA),
        .DataB(DataB),
        .Cout(Cout),
        .Result(Result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Simple Addition (Add_Sub=1, Cin=0)", test_num);
        Add_Sub = 1'b1;
        Cin = 1'b0;
        DataA = 32'h0000_000A;
        DataB = 32'h0000_0014;
        #1;

        check_outputs(1'b0, 32'h0000_001E);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Addition with Carry-in (Add_Sub=1, Cin=1)", test_num);
        Add_Sub = 1'b1;
        Cin = 1'b1;
        DataA = 32'h0000_0005;
        DataB = 32'h0000_0005;
        #1;

        check_outputs(1'b0, 32'h0000_000B);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Addition with Carry-out", test_num);
        Add_Sub = 1'b1;
        Cin = 1'b0;
        DataA = 32'hFFFF_FFFF;
        DataB = 32'h0000_0001;
        #1;

        check_outputs(1'b1, 32'h0000_0000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Addition Max Values", test_num);
        Add_Sub = 1'b1;
        Cin = 1'b1;
        DataA = 32'hFFFF_FFFF;
        DataB = 32'hFFFF_FFFF;
        #1;

        check_outputs(1'b1, 32'hFFFF_FFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Simple Subtraction (Add_Sub=0, Cin=0)", test_num);
        Add_Sub = 1'b0;
        Cin = 1'b0;
        DataA = 32'h0000_0064;
        DataB = 32'h0000_0014;
        #1;

        check_outputs(1'b0, 32'h0000_0050);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Subtraction with Carry-in Borrow", test_num);
        Add_Sub = 1'b0;
        Cin = 1'b1;
        DataA = 32'h0000_000A;
        DataB = 32'h0000_0004;
        #1;

        check_outputs(1'b0, 32'h0000_0005);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Subtraction Borrow-out", test_num);
        Add_Sub = 1'b0;
        Cin = 1'b0;
        DataA = 32'h0000_0005;
        DataB = 32'h0000_000A;
        #1;

        check_outputs(1'b1, 32'hFFFF_FFF6);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Subtraction Zero Result", test_num);
        Add_Sub = 1'b0;
        Cin = 1'b0;
        DataA = 32'h1234_5678;
        DataB = 32'h1234_5678;
        #1;

        check_outputs(1'b0, 32'h0000_0000);
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
        input expected_Cout;
        input [31:0] expected_Result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Cout === (expected_Cout ^ Cout ^ expected_Cout) &&
                expected_Result === (expected_Result ^ Result ^ expected_Result)) begin
                $display("PASS");
                $display("  Outputs: Cout=%b, Result=%h",
                         Cout, Result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Cout=%b, Result=%h",
                         expected_Cout, expected_Result);
                $display("  Got:      Cout=%b, Result=%h",
                         Cout, Result);
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
