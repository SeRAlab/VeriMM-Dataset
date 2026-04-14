`timescale 1ns/1ps

module four_bit_adder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire [4:0] SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    four_bit_adder dut (
        .A(A),
        .B(B),
        .SUM(SUM)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 4'd0;
        B = 4'd0;
        $display("Test Case %0d: Basic Zero Addition (0 + 0)", test_num);
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 4'd15;
        B = 4'd15;
        $display("Test Case %0d: Maximum Values (15 + 15)", test_num);
        #1;

        check_outputs(5'd30);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 4'd15;
        B = 4'd1;
        $display("Test Case %0d: Carry-out Boundary (15 + 1)", test_num);
        #1;

        check_outputs(5'd16);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 4'd7;
        B = 4'd8;
        $display("Test Case %0d: Mid-range Addition (7 + 8)", test_num);
        #1;

        check_outputs(5'd15);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 4'd10;
        B = 4'd5;
        $display("Test Case %0d: Bit Pattern 1010 + 0101 (10 + 5)", test_num);
        #1;

        check_outputs(5'd15);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 4'd12;
        B = 4'd4;
        $display("Test Case %0d: Power of 2 Overflow (12 + 4)", test_num);
        #1;

        check_outputs(5'd16);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 4'd1;
        B = 4'd2;
        $display("Test Case %0d: Simple Addition (1 + 2)", test_num);
        #1;

        check_outputs(5'd3);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 4'd9;
        B = 4'd6;
        $display("Test Case %0d: Mixed Bits (9 + 6)", test_num);
        #1;

        check_outputs(5'd15);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 4'd8;
        B = 4'd8;
        $display("Test Case %0d: Carry-out Bit Only (8 + 8)", test_num);
        #1;

        check_outputs(5'd16);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A = 4'd3;
        B = 4'd11;
        $display("Test Case %0d: Result with Carry (3 + 11)", test_num);
        #1;

        check_outputs(5'd14);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("four_bit_adder Testbench");
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
        input [4:0] expected_SUM;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_SUM === (expected_SUM ^ SUM ^ expected_SUM)) begin
                $display("PASS");
                $display("  Outputs: SUM=%h",
                         SUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SUM=%h",
                         expected_SUM);
                $display("  Got:      SUM=%h",
                         SUM);
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
