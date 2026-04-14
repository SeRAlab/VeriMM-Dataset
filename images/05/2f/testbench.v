`timescale 1ns/1ps

module ALU_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg [3:0] opcode;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU dut (
        .A(A),
        .B(B),
        .opcode(opcode),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: ADD (0x1234 + 0x1111)", test_num);
            A = 16'h1234;
            B = 16'h1111;
            opcode = 4'd0;
            #1;

            check_outputs(16'h2345);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: ADD Wrap-around (0xFFFF + 0x0001)", test_num);
            A = 16'hFFFF;
            B = 16'h0001;
            opcode = 4'd0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: SUBTRACT (0x2222 - 0x1111)", test_num);
            A = 16'h2222;
            B = 16'h1111;
            opcode = 4'd1;
            #1;

            check_outputs(16'h1111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: SUBTRACT Wrap-around (0x0000 - 0x0001)", test_num);
            A = 16'h0000;
            B = 16'h0001;
            opcode = 4'd1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: AND (0xF0F0 & 0xAAAA)", test_num);
            A = 16'hF0F0;
            B = 16'hAAAA;
            opcode = 4'd2;
            #1;

            check_outputs(16'hA0A0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: OR (0xF0F0 | 0x0F0F)", test_num);
            A = 16'hF0F0;
            B = 16'h0F0F;
            opcode = 4'd3;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: XOR (0x1234 ^ 0x1234)", test_num);
            A = 16'h1234;
            B = 16'h1234;
            opcode = 4'd4;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: NOT (A=0x5555, B ignored)", test_num);
            A = 16'h5555;
            B = 16'hFFFF;
            opcode = 4'd5;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: NAND (0x00FF & 0x0FF0)", test_num);
            A = 16'h00FF;
            B = 16'h0FF0;
            opcode = 4'd6;
            #1;

            check_outputs(16'hFF0F);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: NOR (0x00FF | 0xFF00)", test_num);
            A = 16'h00FF;
            B = 16'hFF00;
            opcode = 4'd7;
            #1;

            check_outputs(16'h0000);
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
        input [15:0] expected_result;
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
