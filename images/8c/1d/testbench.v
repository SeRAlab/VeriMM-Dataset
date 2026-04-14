`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg cin;
    reg [15:0] in1;
    reg [15:0] in2;
    wire cout;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cin(cin),
        .in1(in1),
        .in2(in2),
        .cout(cout),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        in1 = 16'h0000; in2 = 16'h0000; cin = 0;
        $display("Testcase %0d: Zero Addition (0 + 0 + 0)", test_num);
        #1;

        check_outputs(1'b0, 16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        in1 = 16'h0005; in2 = 16'h000A; cin = 0;
        $display("Testcase %0d: Simple Addition (5 + 10 + 0)", test_num);
        #1;

        check_outputs(1'b0, 16'h000F);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        in1 = 16'h0001; in2 = 16'h0001; cin = 1;
        $display("Testcase %0d: Addition with Carry-in (1 + 1 + 1)", test_num);
        #1;

        check_outputs(1'b0, 16'h0003);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        in1 = 16'hFFFE; in2 = 16'h0001; cin = 0;
        $display("Testcase %0d: Result is 0xFFFF (No carry-out)", test_num);
        #1;

        check_outputs(1'b0, 16'hFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        in1 = 16'h8000; in2 = 16'h8000; cin = 0;
        $display("Testcase %0d: Simple Overflow (0x8000 + 0x8000)", test_num);
        #1;

        check_outputs(1'b1, 16'h0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        in1 = 16'hFFFF; in2 = 16'h0000; cin = 1;
        $display("Testcase %0d: Carry-in causing Overflow (0xFFFF + 0 + 1)", test_num);
        #1;

        check_outputs(1'b1, 16'h0000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        in1 = 16'hFFFF; in2 = 16'hFFFF; cin = 1;
        $display("Testcase %0d: Maximum sum (0xFFFF + 0xFFFF + 1)", test_num);
        #1;

        check_outputs(1'b1, 16'hFFFF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        in1 = 16'h00FF; in2 = 16'h0001; cin = 0;
        $display("Testcase %0d: Intermediate carry propagation (0x00FF + 1)", test_num);
        #1;

        check_outputs(1'b0, 16'h0100);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        in1 = 16'hAAAA; in2 = 16'h5555; cin = 0;
        $display("Testcase %0d: Complementary Addition (0xAAAA + 0x5555)", test_num);
        #1;

        check_outputs(1'b0, 16'hFFFF);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        in1 = 16'hF000; in2 = 16'h1000; cin = 0;
        $display("Testcase %0d: High bit carry-out (0xF000 + 0x1000)", test_num);
        #1;

        check_outputs(1'b1, 16'h0000);
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
        input expected_cout;
        input [15:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: cout=%b, out=%h",
                         cout, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%b, out=%h",
                         expected_cout, expected_out);
                $display("  Got:      cout=%b, out=%h",
                         cout, out);
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
