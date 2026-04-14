`timescale 1ns/1ps

module ALU_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg [2:0] OP;
    wire CARRY_OUT;
    wire [31:0] RESULT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU dut (
        .A(A),
        .B(B),
        .OP(OP),
        .CARRY_OUT(CARRY_OUT),
        .RESULT(RESULT)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: ADD - Simple Addition", test_num);
            A = 32'h00000005;
            B = 32'h0000000A;
            OP = 3'b000;

            #1;


            check_outputs(1'b0, 32'h0000000F);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: ADD - Overflow Carry", test_num);
            A = 32'hFFFFFFFF;
            B = 32'h00000001;
            OP = 3'b000;

            #1;


            check_outputs(1'b1, 32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: SUBTRACT - Simple Subtraction", test_num);
            A = 32'h00000014;
            B = 32'h00000006;
            OP = 3'b001;




            #1;





            check_outputs(1'b0, 32'h0000000E);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: SUBTRACT - Result with Borrow", test_num);
            A = 32'h00000000;
            B = 32'h00000001;
            OP = 3'b001;

            #1;


            check_outputs(1'b1, 32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: AND - Logical Bitwise", test_num);
            A = 32'hAAAA_AAAA;
            B = 32'hF0F0_F0F0;
            OP = 3'b010;

            #1;


            check_outputs(1'b0, 32'hA0A0_A0A0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: OR - Logical Bitwise", test_num);
            A = 32'h1234_5678;
            B = 32'h8765_4321;
            OP = 3'b011;
            #1;

            check_outputs(1'b0, 32'h9775_5779);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: XOR - Logical Bitwise", test_num);
            A = 32'hFFFF_FFFF;
            B = 32'h1234_5678;
            OP = 3'b100;

            #1;


            check_outputs(1'b0, 32'hEDCB_A987);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: ADD - Large Numbers", test_num);
            A = 32'h7FFFFFFF;
            B = 32'h7FFFFFFF;
            OP = 3'b000;

            #1;


            check_outputs(1'b0, 32'hFFFFFFFE);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: SUBTRACT - Identical numbers", test_num);
            A = 32'hDEADBEEF;
            B = 32'hDEADBEEF;
            OP = 3'b001;
            #1;

            check_outputs(1'b0, 32'h00000000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: AND - Zeros", test_num);
            A = 32'hFFFFFFFF;
            B = 32'h00000000;
            OP = 3'b010;
            #1;

            check_outputs(1'b0, 32'h00000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ALU Testbench");
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
        input [31:0] expected_RESULT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_CARRY_OUT === (expected_CARRY_OUT ^ CARRY_OUT ^ expected_CARRY_OUT) &&
                expected_RESULT === (expected_RESULT ^ RESULT ^ expected_RESULT)) begin
                $display("PASS");
                $display("  Outputs: CARRY_OUT=%b, RESULT=%h",
                         CARRY_OUT, RESULT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CARRY_OUT=%b, RESULT=%h",
                         expected_CARRY_OUT, expected_RESULT);
                $display("  Got:      CARRY_OUT=%b, RESULT=%h",
                         CARRY_OUT, RESULT);
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
