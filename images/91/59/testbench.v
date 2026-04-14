`timescale 1ns/1ps

module alu_32bit_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [2:0] alu_control;
    reg [31:0] b;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    alu_32bit dut (
        .a(a),
        .alu_control(alu_control),
        .b(b),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 32'h0000_000A;
            b = 32'h0000_0005;
            alu_control = 3'b000;
            $display("Test %0d: Addition (10 + 5)", test_num);
            #1;

            check_outputs(32'h0000_000F);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 32'hFFFF_FFFF;
            b = 32'h0000_0001;
            alu_control = 3'b000;
            $display("Test %0d: Addition (Max + 1)", test_num);
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 32'h0000_0014;
            b = 32'h0000_0006;
            alu_control = 3'b001;
            $display("Test %0d: Subtraction (20 - 6)", test_num);
            #1;

            check_outputs(32'h0000_000E);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 32'h0000_0000;
            b = 32'h0000_0001;
            alu_control = 3'b001;
            $display("Test %0d: Subtraction (0 - 1)", test_num);
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 32'hAAAA_AAAA;
            b = 32'h5555_5555;
            alu_control = 3'b010;
            $display("Test %0d: Bitwise AND (Alternating patterns)", test_num);
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 32'hF0F0_F0F0;
            b = 32'hCCCC_CCCC;
            alu_control = 3'b010;
            $display("Test %0d: Bitwise AND", test_num);
            #1;

            check_outputs(32'hC0C0_C0C0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 32'hAAAA_AAAA;
            b = 32'h5555_5555;
            alu_control = 3'b011;
            $display("Test %0d: Bitwise OR", test_num);
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = 32'h1234_5678;
            b = 32'h1234_5678;
            alu_control = 3'b100;
            $display("Test %0d: Bitwise XOR (Same value)", test_num);
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            a = 32'h0000_0001;
            b = 32'h0000_0004;
            alu_control = 3'b101;
            $display("Test %0d: Shift Left Logical (1 << 4)", test_num);
            #1;

            check_outputs(32'h0000_0010);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            a = 32'h0000_0001;
            b = 32'h0000_001F;
            alu_control = 3'b101;
            $display("Test %0d: Shift Left Logical (1 << 31)", test_num);
            #1;

            check_outputs(32'h8000_0000);
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
