`timescale 1ns/1ps

module alu_32bit_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg [2:0] control;
    wire [31:0] result;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    alu_32bit dut (
        .A(A),
        .B(B),
        .control(control),
        .result(result),
        .zero(zero)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: AND operation", test_num);
            A = 32'hF0F0F0F0;
            B = 32'hCCCC3333;
            control = 3'b000;

            #1;


            check_outputs(32'hC0C03030, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: OR operation", test_num);
            A = 32'hF0F0F0F0;
            B = 32'h0F0F0F0F;
            control = 3'b001;

            #1;


            check_outputs(32'hFFFFFFFF, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: ADD operation (Simple)", test_num);
            A = 32'd100;
            B = 32'd250;
            control = 3'b010;

            #1;


            check_outputs(32'd350, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: SUBTRACT operation (Zero Flag)", test_num);
            A = 32'h12345678;
            B = 32'h12345678;
            control = 3'b011;

            #1;


            check_outputs(32'h00000000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: NOR operation", test_num);
            A = 32'h00000000;
            B = 32'h00000000;
            control = 3'b100;

            #1;


            check_outputs(32'hFFFFFFFF, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: NAND operation", test_num);
            A = 32'hFFFFFFFF;
            B = 32'hFFFFFFFF;
            control = 3'b101;

            #1;


            check_outputs(32'h00000000, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: XOR operation", test_num);
            A = 32'hAAAAAAAA;
            B = 32'h55555555;
            control = 3'b110;

            #1;


            check_outputs(32'hFFFFFFFF, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: XNOR operation", test_num);
            A = 32'hAAAAAAAA;
            B = 32'hAAAAAAAA;
            control = 3'b111;

            #1;


            check_outputs(32'hFFFFFFFF, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: ADD operation (Wrap-around)", test_num);
            A = 32'hFFFFFFFF;
            B = 32'h00000001;
            control = 3'b010;

            #1;


            check_outputs(32'h00000000, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: SUBTRACT operation (Negative)", test_num);
            A = 32'd10;
            B = 32'd20;
            control = 3'b011;

            #1;


            check_outputs(32'hFFFFFFF6, 1'b0);
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
