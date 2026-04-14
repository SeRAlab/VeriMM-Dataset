`timescale 1ns/1ps

module ALU_64bit_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] A;
    reg [63:0] B;
    reg [2:0] op_code;
    wire [63:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU_64bit dut (
        .A(A),
        .B(B),
        .op_code(op_code),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition (Small positive)", test_num);
            A = 64'h0000000000000005;
            B = 64'h000000000000000A;
            op_code = 3'b000;
            #1;

            check_outputs(64'h000000000000000F);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition (Overflow/Wrap-around)", test_num);
            A = 64'hFFFFFFFFFFFFFFFF;
            B = 64'h0000000000000001;
            op_code = 3'b000;
            #1;

            check_outputs(64'h0000000000000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction (Positive result)", test_num);
            A = 64'h0000000000000014;
            B = 64'h0000000000000006;
            op_code = 3'b001;
            #1;

            check_outputs(64'h000000000000000E);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction (Negative/Underflow result)", test_num);
            A = 64'h0000000000000000;
            B = 64'h0000000000000001;
            op_code = 3'b001;
            #1;

            check_outputs(64'hFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bitwise AND", test_num);
            A = 64'hAAAA_AAAA_AAAA_AAAA;
            B = 64'hFFFF_0000_FFFF_0000;
            op_code = 3'b010;
            #1;

            check_outputs(64'hAAAA_0000_AAAA_0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bitwise OR", test_num);
            A = 64'h1234_0000_1234_0000;
            B = 64'h0000_5678_0000_5678;
            op_code = 3'b011;
            #1;

            check_outputs(64'h1234_5678_1234_5678);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bitwise XOR", test_num);
            A = 64'hFFFF_FFFF_0000_0000;
            B = 64'hAAAA_AAAA_AAAA_AAAA;
            op_code = 3'b100;
            #1;

            check_outputs(64'h5555_5555_AAAA_AAAA);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Identity XOR (Result should be 0)", test_num);
            A = 64'hDEADBEEFCAFEBABE;
            B = 64'hDEADBEEFCAFEBABE;
            op_code = 3'b100;
            #1;

            check_outputs(64'h0000000000000000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large Subtraction", test_num);
            A = 64'h8000000000000000;
            B = 64'h8000000000000000;
            op_code = 3'b001;
            #1;

            check_outputs(64'h0000000000000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ALU_64bit Testbench");
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
        input [63:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
