`timescale 1ns/1ps

module ALU_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] A;
    reg [2:0] ALUOp;
    reg [63:0] B;
    wire [63:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU dut (
        .A(A),
        .ALUOp(ALUOp),
        .B(B),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Addition", test_num);
            A = 64'h0000000000000005; B = 64'h0000000000000003; ALUOp = 3'b000;
            #1;

            check_outputs(64'h0000000000000008);

            A = 64'hFFFFFFFFFFFFFFFF; B = 64'h0000000000000001; ALUOp = 3'b000;
            #1;

            check_outputs(64'h0000000000000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Subtraction", test_num);
            A = 64'h000000000000000A; B = 64'h0000000000000004; ALUOp = 3'b001;
            #1;

            check_outputs(64'h0000000000000006);

            A = 64'h0000000000000000; B = 64'h0000000000000001; ALUOp = 3'b001;
            #1;

            check_outputs(64'hFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Bitwise AND", test_num);
            A = 64'hF0F0F0F0F0F0F0F0; B = 64'hFFFF0000FFFF0000; ALUOp = 3'b010;
            #1;

            check_outputs(64'hF0F00000F0F00000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Bitwise OR", test_num);
            A = 64'hAAAA_AAAA_AAAA_AAAA; B = 64'h5555_5555_5555_5555; ALUOp = 3'b011;
            #1;

            check_outputs(64'hFFFF_FFFF_FFFF_FFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Bitwise XOR", test_num);
            A = 64'hABCD_1234_EFGH_5678; B = 64'hABCD_1234_EFGH_5678; ALUOp = 3'b100;
            #1;

            check_outputs(64'h0000_0000_0000_0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Left Shift", test_num);
            A = 64'h0000000000000001; B = 64'd1; ALUOp = 3'b101;
            #1;

            check_outputs(64'h0000000000000002);

            A = 64'h0000000000000001; B = 64'd63; ALUOp = 3'b101;
            #1;

            check_outputs(64'h8000000000000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Right Shift", test_num);
            A = 64'h8000000000000000; B = 64'd1; ALUOp = 3'b110;
            #1;

            check_outputs(64'h4000000000000000);

            A = 64'hFFFFFFFFFFFFFFFF; B = 64'd60; ALUOp = 3'b110;
            #1;

            check_outputs(64'h000000000000000F);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Set on Less Than (Signed)", test_num);

            A = 64'd10; B = 64'd20; ALUOp = 3'b111;
            #1;

            check_outputs(64'd1);


            A = 64'd20; B = 64'd10; ALUOp = 3'b111;
            #1;

            check_outputs(64'd0);


            A = 64'hFFFFFFFFFFFFFFFF; B = 64'h0000000000000001; ALUOp = 3'b111;
            #1;

            check_outputs(64'd1);
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
