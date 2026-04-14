`timescale 1ns/1ps

module ALU_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [2:0] ALUOp;
    reg [31:0] B;
    wire [31:0] Result;
    wire Zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU dut (
        .A(A),
        .ALUOp(ALUOp),
        .B(B),
        .Result(Result),
        .Zero(Zero)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: ADD operation (5 + 3)", test_num);
            A = 32'h00000005;
            B = 32'h00000003;
            ALUOp = 3'b000;
            #1;

            check_outputs(32'h00000008, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: SUB operation (10 - 10)", test_num);
            A = 32'd10;
            B = 32'd10;
            ALUOp = 3'b001;
            #1;

            check_outputs(32'h00000000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: SUB operation (1 - 2)", test_num);
            A = 32'd1;
            B = 32'd2;
            ALUOp = 3'b001;
            #1;

            check_outputs(32'hFFFFFFFF, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: AND operation (0xF0F0 & 0xFFFF)", test_num);
            A = 32'h0000F0F0;
            B = 32'hFFFFFFFF;
            ALUOp = 3'b010;
            #1;

            check_outputs(32'h0000F0F0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: OR operation (0xAAAA | 0x5555)", test_num);
            A = 32'hAAAA0000;
            B = 32'h00005555;
            ALUOp = 3'b011;
            #1;

            check_outputs(32'hAAAA5555, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: XOR operation (Identity)", test_num);
            A = 32'h12345678;
            B = 32'h12345678;
            ALUOp = 3'b100;
            #1;

            check_outputs(32'h00000000, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: NAND operation", test_num);
            A = 32'hFFFFFFFF;
            B = 32'h00000001;
            ALUOp = 3'b101;

            #1;


            check_outputs(32'hFFFFFFFE, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: NOR operation", test_num);
            A = 32'h00000000;
            B = 32'h00000000;
            ALUOp = 3'b110;

            #1;


            check_outputs(32'hFFFFFFFF, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: XNOR operation", test_num);
            A = 32'h0000FFFF;
            B = 32'hFFFF0000;
            ALUOp = 3'b111;

            #1;


            check_outputs(32'h00000000, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: ADD operation overflow check", test_num);
            A = 32'hFFFFFFFF;
            B = 32'h00000001;
            ALUOp = 3'b000;

            #1;


            check_outputs(32'h00000000, 1'b1);
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
        input [31:0] expected_Result;
        input expected_Zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Result === (expected_Result ^ Result ^ expected_Result) &&
                expected_Zero === (expected_Zero ^ Zero ^ expected_Zero)) begin
                $display("PASS");
                $display("  Outputs: Result=%h, Zero=%b",
                         Result, Zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Result=%h, Zero=%b",
                         expected_Result, expected_Zero);
                $display("  Got:      Result=%h, Zero=%b",
                         Result, Zero);
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
