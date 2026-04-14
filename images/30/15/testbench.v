`timescale 1ns/1ps

module ALU_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg [2:0] opcode;
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
            $display("Test %0d: Addition (16'h0005 + 16'h000A)", test_num);
            A = 16'h0005;
            B = 16'h000A;
            opcode = 3'b000;
            #1;

            check_outputs(16'h000F);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition Wrap-around (16'hFFFF + 16'h0001)", test_num);
            A = 16'hFFFF;
            B = 16'h0001;
            opcode = 3'b000;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (16'h0020 - 16'h0005)", test_num);
            A = 16'h0020;
            B = 16'h0005;
            opcode = 3'b001;
            #1;

            check_outputs(16'h001B);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction Negative (16'h0000 - 16'h0001)", test_num);
            A = 16'h0000;
            B = 16'h0001;
            opcode = 3'b001;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise AND (16'hF0F0 & 16'hAAAA)", test_num);
            A = 16'hF0F0;
            B = 16'hAAAA;
            opcode = 3'b010;
            #1;

            check_outputs(16'hA0A0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise OR (16'hF0F0 | 16'h0F0F)", test_num);
            A = 16'hF0F0;
            B = 16'h0F0F;
            opcode = 3'b011;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise NOT (~16'h5555)", test_num);
            A = 16'h5555;
            B = 16'h0000;
            opcode = 3'b100;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise NOT (~16'h0000)", test_num);
            A = 16'h0000;
            B = 16'hFFFF;
            opcode = 3'b100;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition Max (16'h7FFF + 16'h7FFF)", test_num);
            A = 16'h7FFF;
            B = 16'h7FFF;
            opcode = 3'b000;
            #1;

            check_outputs(16'hFFFE);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise AND with Zero", test_num);
            A = 16'hFFFF;
            B = 16'h0000;
            opcode = 3'b010;
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
