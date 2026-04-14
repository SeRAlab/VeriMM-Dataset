`timescale 1ns/1ps

module ALU_16bit_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg [1:0] Op;
    wire CarryOut;
    wire [15:0] Result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU_16bit dut (
        .A(A),
        .B(B),
        .Op(Op),
        .CarryOut(CarryOut),
        .Result(Result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Addition without Carry", test_num);
            A = 16'h000A;
            B = 16'h0005;
            Op = 2'b00;
            #1;

            check_outputs(1'b0, 16'h000F);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Addition with Carry", test_num);
            A = 16'hFFFF;
            B = 16'h0001;
            Op = 2'b00;
            #1;

            check_outputs(1'b1, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Subtraction without Borrow", test_num);
            A = 16'h0014;
            B = 16'h0005;
            Op = 2'b01;
            #1;

            check_outputs(1'b0, 16'h000F);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Subtraction with Borrow (Negative Result)", test_num);
            A = 16'h0005;
            B = 16'h000A;
            Op = 2'b01;
            #1;

            check_outputs(1'b1, 16'hFFFB);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Bitwise AND", test_num);
            A = 16'hF0F0;
            B = 16'hAAAA;
            Op = 2'b10;
            #1;

            check_outputs(1'b0, 16'hA0A0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Bitwise AND with Zeros", test_num);
            A = 16'hFFFF;
            B = 16'h0000;
            Op = 2'b10;
            #1;

            check_outputs(1'b0, 16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Addition Max Values", test_num);
            A = 16'h8000;
            B = 16'h8000;
            Op = 2'b00;
            #1;

            check_outputs(1'b1, 16'h0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Subtraction Result Zero", test_num);
            A = 16'h1234;
            B = 16'h1234;
            Op = 2'b01;
            #1;

            check_outputs(1'b0, 16'h0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ALU_16bit Testbench");
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
        input expected_CarryOut;
        input [15:0] expected_Result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_CarryOut === (expected_CarryOut ^ CarryOut ^ expected_CarryOut) &&
                expected_Result === (expected_Result ^ Result ^ expected_Result)) begin
                $display("PASS");
                $display("  Outputs: CarryOut=%b, Result=%h",
                         CarryOut, Result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CarryOut=%b, Result=%h",
                         expected_CarryOut, expected_Result);
                $display("  Got:      CarryOut=%b, Result=%h",
                         CarryOut, Result);
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
