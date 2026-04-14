`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [5:0] ALUFun;
    reg [31:0] B;
    wire [31:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .ALUFun(ALUFun),
        .B(B),
        .S(S)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 32'd4;
            B = 32'h0000000F;
            ALUFun = 6'b000000;
            $display("Test %0d: Left Shift - B=%h by A=%d", test_num, B, A[4:0]);
            #1;

            check_outputs(32'h000000F0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 32'd31;
            B = 32'h00000001;
            ALUFun = 6'b000000;
            $display("Test %0d: Left Shift to MSB - B=%h by A=%d", test_num, B, A[4:0]);
            #1;

            check_outputs(32'h80000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 32'd4;
            B = 32'hF0000000;
            ALUFun = 6'b000001;
            $display("Test %0d: Logical Right Shift - B=%h by A=%d", test_num, B, A[4:0]);
            #1;

            check_outputs(32'h0F000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 32'd31;
            B = 32'hFFFFFFFF;
            ALUFun = 6'b000001;
            $display("Test %0d: Logical Right Shift all but one - B=%h by A=%d", test_num, B, A[4:0]);
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 32'd4;
            B = 32'h70000000;
            ALUFun = 6'b000010;
            $display("Test %0d: Arithmetic Right Shift (Positive) - B=%h by A=%d", test_num, B, A[4:0]);
            #1;

            check_outputs(32'h07000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 32'd8;
            B = 32'h80000000;
            ALUFun = 6'b000010;
            $display("Test %0d: Arithmetic Right Shift (Negative) - B=%h by A=%d", test_num, B, A[4:0]);
            #1;

            check_outputs(32'hFF800000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 32'd31;
            B = 32'h80000000;
            ALUFun = 6'b000010;
            $display("Test %0d: Arithmetic Right Shift (Max) - B=%h by A=%d", test_num, B, A[4:0]);
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 32'd16;
            B = 32'hA5A5A5A5;
            ALUFun = 6'b000011;
            $display("Test %0d: Default case (11) - B=%h", test_num, B);
            #1;

            check_outputs(32'hA5A5A5A5);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            A = 32'd0;
            B = 32'h12345678;
            ALUFun = 6'b000000;
            $display("Test %0d: Shift by 0 - B=%h", test_num, B);
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            A = 32'd1;
            B = 32'h00000001;
            ALUFun = 6'b101000;
            $display("Test %0d: ALUFun high bits check - ALUFun=%b, B=%h", test_num, ALUFun, B);
            #1;

            check_outputs(32'h00000002);
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
        input [31:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: S=%h",
                         S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S=%h",
                         expected_S);
                $display("  Got:      S=%h",
                         S);
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
