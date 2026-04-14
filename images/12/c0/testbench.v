`timescale 1ns/1ps

module alu_32bit_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [2:0] ALUOp;
    reg [31:0] B;
    wire [31:0] Result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    alu_32bit dut (
        .A(A),
        .ALUOp(ALUOp),
        .B(B),
        .Result(Result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition (5 + 10)", test_num);
            A = 32'd5;
            B = 32'd10;
            ALUOp = 3'b000;
            #1;

            check_outputs(32'd15);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (20 - 5)", test_num);
            A = 32'd20;
            B = 32'd5;
            ALUOp = 3'b001;
            #1;

            check_outputs(32'd15);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise AND", test_num);
            A = 32'hF0F0F0F0;
            B = 32'hFFFF0000;
            ALUOp = 3'b010;
            #1;

            check_outputs(32'hF0F00000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise OR", test_num);
            A = 32'hAAAA_AAAA;
            B = 32'h5555_5555;
            ALUOp = 3'b011;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise XOR", test_num);
            A = 32'h1234_5678;
            B = 32'h1234_5678;
            ALUOp = 3'b100;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition Overflow/Rollover", test_num);
            A = 32'hFFFF_FFFF;
            B = 32'h0000_0001;
            ALUOp = 3'b000;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction Resulting in Negative (Two's Complement)", test_num);
            A = 32'h0000_0000;
            B = 32'h0000_0001;
            ALUOp = 3'b001;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large Addition", test_num);
            A = 32'h7FFFFFFF;
            B = 32'h00000001;
            ALUOp = 3'b000;
            #1;

            check_outputs(32'h80000000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: OR with Zero", test_num);
            A = 32'hDEADBEEF;
            B = 32'h00000000;
            ALUOp = 3'b011;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: XOR with All Ones (Inversion)", test_num);
            A = 32'hF0F0F0F0;
            B = 32'hFFFFFFFF;
            ALUOp = 3'b100;
            #1;

            check_outputs(32'h0F0F0F0F);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("alu_32bit Testbench");
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
        input [31:0] expected_Result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Result === (expected_Result ^ Result ^ expected_Result)) begin
                $display("PASS");
                $display("  Outputs: Result=%h",
                         Result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Result=%h",
                         expected_Result);
                $display("  Got:      Result=%h",
                         Result);
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
