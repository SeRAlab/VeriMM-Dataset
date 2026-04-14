`timescale 1ns/1ps

module Adder64_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] A;
    reg [63:0] B;
    wire CARRY_OUT;
    wire [63:0] SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    Adder64 dut (
        .A(A),
        .B(B),
        .CARRY_OUT(CARRY_OUT),
        .SUM(SUM)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Adding zeros", test_num);
        A = 64'h0;
        B = 64'h0;
        #1;

        check_outputs(1'b0, 64'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Simple addition (1+1)", test_num);
        A = 64'h1;
        B = 64'h1;
        #1;

        check_outputs(1'b0, 64'h2);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Carry out check (Max + 1)", test_num);
        A = 64'hFFFFFFFFFFFFFFFF;
        B = 64'h1;
        #1;

        check_outputs(1'b1, 64'h0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Alternating bits", test_num);
        A = 64'hAAAAAAAAAAAAAAAA;
        B = 64'h5555555555555555;
        #1;

        check_outputs(1'b0, 64'hFFFFFFFFFFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Max + Max addition", test_num);
        A = 64'hFFFFFFFFFFFFFFFF;
        B = 64'hFFFFFFFFFFFFFFFF;
        #1;

        check_outputs(1'b1, 64'hFFFFFFFFFFFFFFFE);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Carry propagation check", test_num);
        A = 64'h00000000FFFFFFFF;
        B = 64'h0000000000000001;
        #1;

        check_outputs(1'b0, 64'h0000000100000000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Large arbitrary values", test_num);
        A = 64'h123456789ABCDEF0;
        B = 64'h0EDCBA9876543210;
        #1;

        check_outputs(1'b0, 64'h2111111111111100);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: MSB addition carry", test_num);
        A = 64'h8000000000000000;
        B = 64'h8000000000000000;
        #1;

        check_outputs(1'b1, 64'h0000000000000000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("Adder64 Testbench");
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
        input expected_CARRY_OUT;
        input [63:0] expected_SUM;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_CARRY_OUT === (expected_CARRY_OUT ^ CARRY_OUT ^ expected_CARRY_OUT) &&
                expected_SUM === (expected_SUM ^ SUM ^ expected_SUM)) begin
                $display("PASS");
                $display("  Outputs: CARRY_OUT=%b, SUM=%h",
                         CARRY_OUT, SUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CARRY_OUT=%b, SUM=%h",
                         expected_CARRY_OUT, expected_SUM);
                $display("  Got:      CARRY_OUT=%b, SUM=%h",
                         CARRY_OUT, SUM);
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
