`timescale 1ns/1ps

module adder64_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] A;
    reg [63:0] B;
    wire CarryOut;
    wire [63:0] Sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder64 dut (
        .A(A),
        .B(B),
        .CarryOut(CarryOut),
        .Sum(Sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero addition", test_num);
            A = 64'h0000000000000000;
            B = 64'h0000000000000000;
            #1;

            check_outputs(1'b0, 64'h0000000000000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Identity addition", test_num);
            A = 64'hFEDCBA9876543210;
            B = 64'h0000000000000000;
            #1;

            check_outputs(1'b0, 64'hFEDCBA9876543210);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple addition without carry out", test_num);
            A = 64'h0000000000000001;
            B = 64'h0000000000000001;
            #1;

            check_outputs(1'b0, 64'h0000000000000002);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max value without carry out", test_num);
            A = 64'hFFFFFFFFFFFFFFFF;
            B = 64'h0000000000000000;
            #1;

            check_outputs(1'b0, 64'hFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Carry out generation (All Fs + 1)", test_num);
            A = 64'hFFFFFFFFFFFFFFFF;
            B = 64'h0000000000000001;
            #1;

            check_outputs(1'b1, 64'h0000000000000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large addition with carry out", test_num);
            A = 64'hFFFFFFFFFFFFFFFF;
            B = 64'hFFFFFFFFFFFFFFFF;
            #1;

            check_outputs(1'b1, 64'hFFFFFFFFFFFFFFFE);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bit patterns", test_num);
            A = 64'hAAAAAAAAAAAAAAAA;
            B = 64'h5555555555555555;
            #1;

            check_outputs(1'b0, 64'hFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random-style pattern with middle carry", test_num);
            A = 64'h1234567812345678;
            B = 64'h8765432187654321;
            #1;

            check_outputs(1'b0, 64'h9999999999999999);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary carry into MSB", test_num);
            A = 64'h7FFFFFFFFFFFFFFF;
            B = 64'h0000000000000001;
            #1;

            check_outputs(1'b0, 64'h8000000000000000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Carry out with sparse bits", test_num);
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
        $display("adder64 Testbench");
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
        input [63:0] expected_Sum;
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
