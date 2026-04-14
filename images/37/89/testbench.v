`timescale 1ns/1ps

module ALU_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [2:0] ALU_control;
    reg [31:0] B;
    wire [31:0] result;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU dut (
        .A(A),
        .ALU_control(ALU_control),
        .B(B),
        .result(result),
        .zero(zero)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Addition (5 + 10)", test_num);
            ALU_control = 3'b000;
            A = 32'd5;
            B = 32'd10;
            #1;

            check_outputs(32'd15, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Subtraction (50 - 50)", test_num);
            ALU_control = 3'b001;
            A = 32'd50;
            B = 32'd50;
            #1;

            check_outputs(32'd0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Subtraction (10 - 20)", test_num);
            ALU_control = 3'b001;
            A = 32'd10;
            B = 32'd20;

            #1;


            check_outputs(32'hfffffff6, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Bitwise AND", test_num);
            ALU_control = 3'b010;
            A = 32'hF0F0F0F0;
            B = 32'hFFFF0000;
            #1;

            check_outputs(32'hF0F00000, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Bitwise OR", test_num);
            ALU_control = 3'b011;
            A = 32'h12340000;
            B = 32'h00005678;
            #1;

            check_outputs(32'h12345678, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Bitwise XOR", test_num);
            ALU_control = 3'b100;
            A = 32'hAAAAAAAA;
            B = 32'hFFFFFFFF;
            #1;

            check_outputs(32'h55555555, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Logical Left Shift (1 << 4)", test_num);
            ALU_control = 3'b101;
            A = 32'h00000001;
            B = 32'd4;
            #1;

            check_outputs(32'h00000010, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Logical Right Shift (0x80 >> 3)", test_num);
            ALU_control = 3'b110;
            A = 32'h00000080;
            B = 32'd3;
            #1;

            check_outputs(32'h00000010, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: SLT (Signed: -1 < 1)", test_num);
            ALU_control = 3'b111;
            A = 32'hFFFFFFFF;
            B = 32'h00000001;
            #1;

            check_outputs(32'h00000001, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: SLT (Signed: 10 < 5)", test_num);
            ALU_control = 3'b111;
            A = 32'sd10;
            B = 32'sd5;

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
        input [31:0] expected_result;
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: result=%h, zero=%b",
                         result, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h, zero=%b",
                         expected_result, expected_zero);
                $display("  Got:      result=%h, zero=%b",
                         result, zero);
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
