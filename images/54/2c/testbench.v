`timescale 1ns/1ps

module alu_32bit_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg [2:0] op;
    wire [31:0] result;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    alu_32bit dut (
        .a(a),
        .b(b),
        .op(op),
        .result(result),
        .zero(zero)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: AND Operation (op=000)", test_num);
            a = 32'hAAAA_AAAA;
            b = 32'h5555_5555;
            op = 3'b000;
            #1;

            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: OR Operation (op=001)", test_num);
            a = 32'hF0F0_F0F0;
            b = 32'h0F0F_0F0F;
            op = 3'b001;
            #1;

            check_outputs(32'hFFFF_FFFF, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: ADD Operation (op=010)", test_num);
            a = 32'd100;
            b = 32'd250;
            op = 3'b010;
            #1;

            check_outputs(32'd350, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: ADD Overflow to Zero (op=010)", test_num);
            a = 32'hFFFF_FFFF;
            b = 32'h0000_0001;
            op = 3'b010;
            #1;

            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: SUB Operation (op=011)", test_num);
            a = 32'd500;
            b = 32'd200;
            op = 3'b011;
            #1;

            check_outputs(32'd300, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: SUB Result Negative (op=011)", test_num);
            a = 32'd10;
            b = 32'd20;
            op = 3'b011;

            #1;


            check_outputs(32'hFFF_FFF_F6, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: XOR Operation (op=100)", test_num);
            a = 32'h1234_5678;
            b = 32'h1234_5678;
            op = 3'b100;
            #1;

            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: SLL (Shift Left Logical) (op=101)", test_num);
            a = 32'h0000_0001;
            b = 32'd4;
            op = 3'b101;
            #1;

            check_outputs(32'h0000_0010, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: SRL (Shift Right Logical) (op=110)", test_num);
            a = 32'h8000_0000;
            b = 32'd1;
            op = 3'b110;
            #1;

            check_outputs(32'h4000_0000, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: SRA (Shift Right Arithmetic) (op=111)", test_num);
            a = 32'h8000_0000;
            b = 32'd2;
            op = 3'b111;

            #1;


            check_outputs(32'hE000_0000, 1'b0);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: SRA (Shift Right Arithmetic Positive) (op=111)", test_num);
            a = 32'h4000_0000;
            b = 32'd2;
            op = 3'b111;

            #1;


            check_outputs(32'h1000_0000, 1'b0);
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
        testcase011();
        
        
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
