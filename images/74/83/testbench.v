`timescale 1ns/1ps

module alu_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [2:0] alu_ctrl;
    reg [31:0] b;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    alu dut (
        .a(a),
        .alu_ctrl(alu_ctrl),
        .b(b),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition (a + b)", test_num);
            a = 32'h0000_0005;
            b = 32'h0000_000A;
            alu_ctrl = 3'b000;
            #1;

            check_outputs(32'h0000_000F);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition with Overflow", test_num);
            a = 32'hFFFF_FFFF;
            b = 32'h0000_0001;
            alu_ctrl = 3'b000;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (a - b)", test_num);
            a = 32'h0000_0014;
            b = 32'h0000_0006;
            alu_ctrl = 3'b001;
            #1;

            check_outputs(32'h0000_000E);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (Negative Result)", test_num);
            a = 32'h0000_0005;
            b = 32'h0000_000A;
            alu_ctrl = 3'b001;
            #1;

            check_outputs(32'hFFFF_FFFB);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise AND", test_num);
            a = 32'hF0F0_AAAA;
            b = 32'hFF00_5555;
            alu_ctrl = 3'b010;
            #1;

            check_outputs(32'hF000_0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise OR", test_num);
            a = 32'hF0F0_AAAA;
            b = 32'h0F0F_5555;
            alu_ctrl = 3'b011;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise XOR", test_num);
            a = 32'h1234_5678;
            b = 32'h1234_FFFF;
            alu_ctrl = 3'b100;
            #1;

            check_outputs(32'h0000_A987);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise XOR Identical", test_num);
            a = 32'hABCD_EF01;
            b = 32'hABCD_EF01;
            alu_ctrl = 3'b100;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("alu Testbench");
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
        input [31:0] expected_result;
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
