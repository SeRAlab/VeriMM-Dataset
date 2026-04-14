`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in;
    wire [3:0] Address;
    wire [15:0] Data;
    wire Match;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .Address(Address),
        .Data(Data),
        .Match(Match),
        .out(out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Search for key 0x00 (Expected: Match at Address 0)", test_num);
        in = 8'h00;

        #1;


        check_outputs(4'h0, 16'h0000, 1'b1, 16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Search for key 0x07 (Expected: Match at Address 7)", test_num);
        in = 8'h07;

        #1;


        check_outputs(4'h7, 16'h7777, 1'b1, 16'h7777);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Search for key 0x0F (Expected: Match at Address 15)", test_num);
        in = 8'h0F;

        #1;


        check_outputs(4'hF, 16'hFFFF, 1'b1, 16'hFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Search for key 0xFF (Expected: No Match)", test_num);
        in = 8'hFF;

        #1;


        check_outputs(4'h0, 16'h0000, 1'b0, 16'h0000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Search for key 0x8A (Expected: No Match)", test_num);
        in = 8'h8A;

        #1;


        check_outputs(4'h0, 16'h0000, 1'b0, 16'h0000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Search for key 0x0A (Expected: Match at Address 10)", test_num);
        in = 8'h0A;

        #1;


        check_outputs(4'hA, 16'hAAAA, 1'b1, 16'hAAAA);
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
        input [3:0] expected_Address;
        input [15:0] expected_Data;
        input expected_Match;
        input [15:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Address === (expected_Address ^ Address ^ expected_Address) &&
                expected_Data === (expected_Data ^ Data ^ expected_Data) &&
                expected_Match === (expected_Match ^ Match ^ expected_Match) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: Address=%h, Data=%h, Match=%b, out=%h",
                         Address, Data, Match, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Address=%h, Data=%h, Match=%b, out=%h",
                         expected_Address, expected_Data, expected_Match, expected_out);
                $display("  Got:      Address=%h, Data=%h, Match=%b, out=%h",
                         Address, Data, Match, out);
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
