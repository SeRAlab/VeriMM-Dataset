`timescale 1ns/1ps

module BrentKungAdder_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] A;
    reg [4:0] B;
    wire CarryOut;
    wire [4:0] Sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    BrentKungAdder dut (
        .A(A),
        .B(B),
        .CarryOut(CarryOut),
        .Sum(Sum)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        A = 5'd0; B = 5'd0;
        $display("Testcase %0d: A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(1'b0, 5'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        A = 5'd15; B = 5'd0;
        $display("Testcase %0d: A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(1'b0, 5'd15);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        A = 5'd10; B = 5'd5;
        $display("Testcase %0d: A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(1'b0, 5'd15);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        A = 5'd31; B = 5'd0;
        $display("Testcase %0d: A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(1'b0, 5'd31);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        A = 5'd31; B = 5'd1;
        $display("Testcase %0d: A=%d, B=%d (Overflow Check)", test_num, A, B);
        #1;

        check_outputs(1'b1, 5'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        A = 5'd16; B = 5'd16;
        $display("Testcase %0d: A=%d, B=%d (Single CarryOut Check)", test_num, A, B);
        #1;

        check_outputs(1'b1, 5'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        A = 5'd31; B = 5'd31;
        $display("Testcase %0d: A=%d, B=%d (Max Sum Check)", test_num, A, B);
        #1;

        check_outputs(1'b1, 5'd30);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        A = 5'd21; B = 5'd10;
        $display("Testcase %0d: A=10101, B=01010 (Alternating Bits)", test_num);
        #1;

        check_outputs(1'b0, 5'b11111);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        A = 5'd7; B = 5'd1;
        $display("Testcase %0d: A=%d, B=%d (Internal Carry Propagation)", test_num, A, B);
        #1;

        check_outputs(1'b0, 5'd8);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        A = 5'd25; B = 5'd10;
        $display("Testcase %0d: A=%d, B=%d (Result 35 mod 32)", test_num, A, B);
        #1;

        check_outputs(1'b1, 5'd3);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("BrentKungAdder Testbench");
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
        input expected_CarryOut;
        input [4:0] expected_Sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_CarryOut === (expected_CarryOut ^ CarryOut ^ expected_CarryOut) &&
                expected_Sum === (expected_Sum ^ Sum ^ expected_Sum)) begin
                $display("PASS");
                $display("  Outputs: CarryOut=%b, Sum=%h",
                         CarryOut, Sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CarryOut=%b, Sum=%h",
                         expected_CarryOut, expected_Sum);
                $display("  Got:      CarryOut=%b, Sum=%h",
                         CarryOut, Sum);
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
