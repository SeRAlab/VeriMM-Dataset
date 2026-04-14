`timescale 1ns/1ps

module adder_16bit_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    wire CARRY_OUT;
    wire [15:0] SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder_16bit dut (
        .A(A),
        .B(B),
        .CARRY_OUT(CARRY_OUT),
        .SUM(SUM)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 1: Zero Addition");
        A = 16'h0000;
        B = 16'h0000;
        #1;

        check_outputs(1'b0, 16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 2: Basic Addition");
        A = 16'h0005;
        B = 16'h000A;
        #1;

        check_outputs(1'b0, 16'h000F);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 3: Max Value + 0");
        A = 16'hFFFF;
        B = 16'h0000;
        #1;

        check_outputs(1'b0, 16'hFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 4: Boundary Overflow (FFFF + 1)");
        A = 16'hFFFF;
        B = 16'h0001;
        #1;

        check_outputs(1'b1, 16'h0000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 5: Maximum Possible Sum (FFFF + FFFF)");
        A = 16'hFFFF;
        B = 16'hFFFF;
        #1;

        check_outputs(1'b1, 16'hFFFE);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 6: MSB Addition (8000 + 8000)");
        A = 16'h8000;
        B = 16'h8000;
        #1;

        check_outputs(1'b1, 16'h0000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 7: Arbitrary Addition (1234 + 5678)");
        A = 16'h1234;
        B = 16'h5678;
        #1;

        check_outputs(1'b0, 16'h68AC);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 8: Arbitrary Overflow (ABCD + DCBA)");
        A = 16'hABCD;
        B = 16'hDCBA;
        #1;

        check_outputs(1'b1, 16'h8887);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case 9: Pattern 5555 + AAAA");
        A = 16'h5555;
        B = 16'hAAAA;
        #1;

        check_outputs(1'b0, 16'hFFFF);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case 10: FFF0 + 0020");
        A = 16'hFFF0;
        B = 16'h0020;
        #1;

        check_outputs(1'b1, 16'h0010);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder_16bit Testbench");
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
        input expected_CARRY_OUT;
        input [15:0] expected_SUM;
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
