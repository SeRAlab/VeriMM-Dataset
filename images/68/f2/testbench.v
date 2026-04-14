`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [2:0] ALU_operation;
    reg [31:0] B;
    wire overflow;
    wire [31:0] res;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .ALU_operation(ALU_operation),
        .B(B),
        .overflow(overflow),
        .res(res),
        .zero(zero)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: bitwise AND", test_num);
        A = 32'hF0F0F0F0; B = 32'hFFFF0000; ALU_operation = 3'b000;
        #1;

        check_outputs(1'b0, 32'hF0F00000, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: bitwise OR", test_num);
        A = 32'hAAAA_AAAA; B = 32'h5555_5555; ALU_operation = 3'b001;
        #1;

        check_outputs(1'b0, 32'hFFFF_FFFF, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition (Normal)", test_num);
        A = 32'd123; B = 32'd456; ALU_operation = 3'b010;
        #1;

        check_outputs(1'b0, 32'd579, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition (Overflow Positive)", test_num);
        A = 32'h7FFFFFFF; B = 32'h00000001; ALU_operation = 3'b010;

        #1;


        check_outputs(1'b1, 32'h80000000, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction (Normal)", test_num);
        A = 32'd1000; B = 32'd300; ALU_operation = 3'b011;
        #1;

        check_outputs(1'b0, 32'd700, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction (Overflow Negative Result)", test_num);
        A = 32'h80000000; B = 32'h00000001; ALU_operation = 3'b011;

        #1;


        check_outputs(1'b1, 32'h7FFFFFFF, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: bitwise NOR", test_num);
        A = 32'h0000FFFF; B = 32'h00FF00FF; ALU_operation = 3'b100;

        #1;


        check_outputs(1'b0, 32'hFF000000, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SLT (True, Signed)", test_num);
        A = 32'hFFFFFFFF; B = 32'h00000001; ALU_operation = 3'b101;
        #1;

        check_outputs(1'b0, 32'h00000001, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SLT (False, Signed)", test_num);
        A = 32'h00000005; B = 32'h00000002; ALU_operation = 3'b101;
        #1;

        check_outputs(1'b0, 32'h00000000, 1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Right Shift Logical", test_num);
        A = 32'h80000000; B = 32'd4; ALU_operation = 3'b110;
        #1;

        check_outputs(1'b0, 32'h08000000, 1'b0);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test %0d: bitwise XOR", test_num);
        A = 32'hF0F0F0F0; B = 32'h0F0F0F0F; ALU_operation = 3'b111;
        #1;

        check_outputs(1'b0, 32'hFFFFFFFF, 1'b0);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Zero Flag check (SUB)", test_num);
        A = 32'h55AA55AA; B = 32'h55AA55AA; ALU_operation = 3'b011;
        #1;

        check_outputs(1'b0, 32'h00000000, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        testcase011();
        testcase012();
        
        
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
        input expected_overflow;
        input [31:0] expected_res;
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_res === (expected_res ^ res ^ expected_res) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: overflow=%b, res=%h, zero=%b",
                         overflow, res, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: overflow=%b, res=%h, zero=%b",
                         expected_overflow, expected_res, expected_zero);
                $display("  Got:      overflow=%b, res=%h, zero=%b",
                         overflow, res, zero);
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
