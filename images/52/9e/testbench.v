`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg ALU_OUT;
    reg [31:0] B;
    reg [3:0] FLAGS;
    reg [4:0] OP;
    reg S;
    wire [3:0] FLAGS_OUT;
    wire [31:0] Out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .ALU_OUT(ALU_OUT),
        .B(B),
        .FLAGS(FLAGS),
        .OP(OP),
        .S(S),
        .FLAGS_OUT(FLAGS_OUT),
        .Out(Out)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 32'h0000000A;
            B = 32'h00000014;
            OP = 5'b00000;
            S = 1'b0;
            ALU_OUT = 1'b1;
            FLAGS = 4'b0000;
            #10;

            #1;


            check_outputs(4'b0000, 32'h0000001E);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 32'h00000032;
            B = 32'h0000000A;
            OP = 5'b00001;
            S = 1'b0;
            ALU_OUT = 1'b1;
            FLAGS = 4'b0000;
            #10;

            #1;


            check_outputs(4'b0000, 32'h00000028);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 32'hF0F0F0F0;
            B = 32'hFFFF0000;
            OP = 5'b00010;
            S = 1'b0;
            ALU_OUT = 1'b1;
            FLAGS = 4'b0000;
            #10;

            #1;


            check_outputs(4'b0000, 32'hF0F00000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 32'hAAAAAAAA;
            B = 32'h55555555;
            OP = 5'b00100;
            S = 1'b0;
            ALU_OUT = 1'b1;
            FLAGS = 4'b0000;
            #10;

            #1;


            check_outputs(4'b0100, 32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 32'h12345678;
            B = 32'h00000001;
            OP = 5'b00000;
            S = 1'b0;
            ALU_OUT = 1'b0;
            FLAGS = 4'b0000;
            #10;

            #1;


            check_outputs(4'b0000, 32'bz);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 32'h00000005;
            B = 32'h00000005;
            OP = 5'b00001;
            S = 1'b0;
            ALU_OUT = 1'b1;
            FLAGS = 4'b0000;
            #10;

            #1;


            check_outputs(4'b0001, 32'h00000000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 32'h00000001;
            B = 32'h00000002;
            OP = 5'b00001;
            S = 1'b0;
            ALU_OUT = 1'b1;
            FLAGS = 4'b0000;
            #10;

            #1;


            check_outputs(4'b0100, 32'hFFFFFFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 32'h7FFFFFFF;
            B = 32'h00000001;
            OP = 5'b00000;
            S = 1'b0;
            ALU_OUT = 1'b1;
            FLAGS = 4'b0000;
            #10;

            #1;


            check_outputs(4'b0110, 32'h80000000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            A = 32'hCAFECAFE;
            B = 32'hBABEBEBE;
            OP = 5'b00000;
            S = 1'b1;
            ALU_OUT = 1'b1;
            FLAGS = 4'b1111;
            #10;


            $display("Checking S-input and FLAGS-input influence...");
            #1;

            check_outputs(FLAGS_OUT, Out);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            A = 32'h12345678;
            B = 32'h87654321;
            OP = 5'b00011;
            S = 1'b0;
            ALU_OUT = 1'b1;
            FLAGS = 4'b0000;
            #10;

            #1;


            check_outputs(4'b0100, 32'h97755779);
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
        input [3:0] expected_FLAGS_OUT;
        input [31:0] expected_Out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_FLAGS_OUT === (expected_FLAGS_OUT ^ FLAGS_OUT ^ expected_FLAGS_OUT) &&
                expected_Out === (expected_Out ^ Out ^ expected_Out)) begin
                $display("PASS");
                $display("  Outputs: FLAGS_OUT=%h, Out=%h",
                         FLAGS_OUT, Out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: FLAGS_OUT=%h, Out=%h",
                         expected_FLAGS_OUT, expected_Out);
                $display("  Got:      FLAGS_OUT=%h, Out=%h",
                         FLAGS_OUT, Out);
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
