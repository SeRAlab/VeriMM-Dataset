`timescale 1ns/1ps

module Adder32Bit_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    wire COUT;
    wire [31:0] SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    Adder32Bit dut (
        .A(A),
        .B(B),
        .COUT(COUT),
        .SUM(SUM)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Simple Addition (No Carry)", test_num);
        A = 32'h00000005;
        B = 32'h0000000A;
        #1;

        check_outputs(1'b0, 32'h0000000F);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Zero Addition", test_num);
        A = 32'h00000000;
        B = 32'h00000000;
        #1;

        check_outputs(1'b0, 32'h00000000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Maximum Value + 1 (Carry Trigger)", test_num);
        A = 32'hFFFFFFFF;
        B = 32'h00000001;
        #1;

        check_outputs(1'b1, 32'h00000000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Maximum Value + Maximum Value", test_num);
        A = 32'hFFFFFFFF;
        B = 32'hFFFFFFFF;
        #1;

        check_outputs(1'b1, 32'hFFFFFFFE);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Alternating Bits", test_num);
        A = 32'hAAAAAAAA;
        B = 32'h55555555;
        #1;

        check_outputs(1'b0, 32'hFFFFFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Large Numbers (No Carry)", test_num);
        A = 32'h12345678;
        B = 32'h87654321;
        #1;

        check_outputs(1'b0, 32'h99999999);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Midpoint Carry", test_num);
        A = 32'h80000000;
        B = 32'h80000000;
        #1;

        check_outputs(1'b1, 32'h00000000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Boundary Carry (0x7FFFFFFF + 0x80000001)", test_num);
        A = 32'h7FFFFFFF;
        B = 32'h80000001;
        #1;

        check_outputs(1'b1, 32'h00000000);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Random Addition 1", test_num);
        A = 32'hA5A5A5A5;
        B = 32'h5A5A5A5A;
        #1;

        check_outputs(1'b0, 32'hFFFFFFFF);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Random Addition 2 (With Carry)", test_num);
        A = 32'hF0F0F0F0;
        B = 32'h10101010;
        #1;

        check_outputs(1'b1, 32'h01010100);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("Adder32Bit Testbench");
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
        input expected_COUT;
        input [31:0] expected_SUM;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_COUT === (expected_COUT ^ COUT ^ expected_COUT) &&
                expected_SUM === (expected_SUM ^ SUM ^ expected_SUM)) begin
                $display("PASS");
                $display("  Outputs: COUT=%b, SUM=%h",
                         COUT, SUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: COUT=%b, SUM=%h",
                         expected_COUT, expected_SUM);
                $display("  Got:      COUT=%b, SUM=%h",
                         COUT, SUM);
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
