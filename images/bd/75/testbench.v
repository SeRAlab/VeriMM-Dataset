`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg C0;
    wire Co;
    wire [31:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C0(C0),
        .Co(Co),
        .S(S)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Simple Addition (No Carry)", test_num);
        A = 32'h0000_0005;
        B = 32'h0000_000A;
        C0 = 1'b0;
        #1;

        check_outputs(1'b0, 32'h0000_000F);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Addition with Carry-in", test_num);
        A = 32'h0000_0100;
        B = 32'h0000_0200;
        C0 = 1'b1;
        #1;

        check_outputs(1'b0, 32'h0000_0301);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum value (No Co)", test_num);
        A = 32'hFFFF_FFFE;
        B = 32'h0000_0001;
        C0 = 1'b0;
        #1;

        check_outputs(1'b0, 32'hFFFF_FFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Carry-out Generation (A+B)", test_num);
        A = 32'hFFFF_FFFF;
        B = 32'h0000_0001;
        C0 = 1'b0;
        #1;

        check_outputs(1'b1, 32'h0000_0000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Carry-out via C0", test_num);
        A = 32'hFFFF_FFFF;
        B = 32'h0000_0000;
        C0 = 1'b1;
        #1;

        check_outputs(1'b1, 32'h0000_0000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum Sum (All Ones)", test_num);
        A = 32'hFFFF_FFFF;
        B = 32'hFFFF_FFFF;
        C0 = 1'b1;
        #1;

        check_outputs(1'b1, 32'hFFFF_FFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero Inputs", test_num);
        A = 32'h0000_0000;
        B = 32'h0000_0000;
        C0 = 1'b0;
        #1;

        check_outputs(1'b0, 32'h0000_0000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bit Pattern Addition", test_num);
        A = 32'hAAAA_AAAA;
        B = 32'h5555_5555;
        C0 = 1'b0;
        #1;

        check_outputs(1'b0, 32'hFFFF_FFFF);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bit Pattern with Overflow", test_num);
        A = 32'hAAAA_AAAA;
        B = 32'hAAAA_AAAA;
        C0 = 1'b0;
        #1;

        check_outputs(1'b1, 32'h5555_5554);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Mid-word Carry Propagation", test_num);
        A = 32'h0000_FFFF;
        B = 32'h0000_0000;
        C0 = 1'b1;
        #1;

        check_outputs(1'b0, 32'h0001_0000);
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
        input expected_Co;
        input [31:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Co === (expected_Co ^ Co ^ expected_Co) &&
                expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: Co=%b, S=%h",
                         Co, S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Co=%b, S=%h",
                         expected_Co, expected_S);
                $display("  Got:      Co=%b, S=%h",
                         Co, S);
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
