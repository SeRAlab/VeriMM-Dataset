`timescale 1ns/1ps

module ALU_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [2:0] control;
    wire [7:0] result;
    wire zero_flag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU_8bit dut (
        .A(A),
        .B(B),
        .control(control),
        .result(result),
        .zero_flag(zero_flag)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: AND Operation", test_num);
            control = 3'b000;
            A = 8'hAA;
            B = 8'hF0;
            #1;

            check_outputs(8'hA0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: AND Operation (Zero Flag)", test_num);
            control = 3'b000;
            A = 8'h0F;
            B = 8'hF0;
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: OR Operation", test_num);
            control = 3'b001;
            A = 8'h55;
            B = 8'hAA;
            #1;

            check_outputs(8'hFF, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: ADD Operation", test_num);
            control = 3'b010;
            A = 8'h12;
            B = 8'h34;
            #1;

            check_outputs(8'h46, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: ADD Operation (Wrap to Zero)", test_num);
            control = 3'b010;
            A = 8'hFF;
            B = 8'h01;
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: SUBTRACT Operation", test_num);
            control = 3'b011;
            A = 8'h20;
            B = 8'h05;
            #1;

            check_outputs(8'h1B, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: SUBTRACT Operation (Zero Flag)", test_num);
            control = 3'b011;
            A = 8'hEE;
            B = 8'hEE;
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: XOR Operation", test_num);
            control = 3'b100;
            A = 8'hFF;
            B = 8'h0F;
            #1;

            check_outputs(8'hF0, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: XOR Operation (Zero Flag)", test_num);
            control = 3'b100;
            A = 8'hCC;
            B = 8'hCC;
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: SUBTRACT Operation (Underflow)", test_num);
            control = 3'b011;
            A = 8'h00;
            B = 8'h01;
            #1;

            check_outputs(8'hFF, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ALU_8bit Testbench");
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
        input [7:0] expected_result;
        input expected_zero_flag;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result) &&
                expected_zero_flag === (expected_zero_flag ^ zero_flag ^ expected_zero_flag)) begin
                $display("PASS");
                $display("  Outputs: result=%h, zero_flag=%b",
                         result, zero_flag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h, zero_flag=%b",
                         expected_result, expected_zero_flag);
                $display("  Got:      result=%h, zero_flag=%b",
                         result, zero_flag);
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
