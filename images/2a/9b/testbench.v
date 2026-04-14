`timescale 1ns/1ps

module ALU_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg [2:0] opcode;
    wire Z;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU dut (
        .A(A),
        .B(B),
        .opcode(opcode),
        .Z(Z),
        .result(result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Addition (10 + 20)", test_num);
        A = 32'd10;
        B = 32'd20;
        opcode = 3'b000;
        #1;

        check_outputs(1'b0, 32'd30);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Addition with Zero result (0xFFFFFFFF + 1)", test_num);
        A = 32'hFFFFFFFF;
        B = 32'h00000001;
        opcode = 3'b000;
        #1;

        check_outputs(1'b1, 32'h00000000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Subtraction (50 - 20)", test_num);
        A = 32'd50;
        B = 32'd20;
        opcode = 3'b001;
        #1;

        check_outputs(1'b0, 32'd30);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Subtraction resulting in Zero (100 - 100)", test_num);
        A = 32'd100;
        B = 32'd100;
        opcode = 3'b001;
        #1;

        check_outputs(1'b1, 32'h00000000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bitwise AND", test_num);
        A = 32'hF0F0F0F0;
        B = 32'hAAAA5555;
        opcode = 3'b010;
        #1;

        check_outputs(1'b0, 32'hA0A05050);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bitwise AND Zero check", test_num);
        A = 32'hF0F0F0F0;
        B = 32'h0F0F0F0F;
        opcode = 3'b010;
        #1;

        check_outputs(1'b1, 32'h00000000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bitwise OR", test_num);
        A = 32'h12340000;
        B = 32'h00005678;
        opcode = 3'b011;
        #1;

        check_outputs(1'b0, 32'h12345678);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bitwise OR Zero check", test_num);
        A = 32'h00000000;
        B = 32'h00000000;
        opcode = 3'b011;
        #1;

        check_outputs(1'b1, 32'h00000000);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bitwise XOR", test_num);
        A = 32'hFFFFFFFF;
        B = 32'h12345678;
        opcode = 3'b100;
        #1;

        check_outputs(1'b0, ~32'h12345678);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bitwise XOR Zero check", test_num);
        A = 32'hABCDE123;
        B = 32'hABCDE123;
        opcode = 3'b100;
        #1;

        check_outputs(1'b1, 32'h00000000);
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
        input expected_Z;
        input [31:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Z === (expected_Z ^ Z ^ expected_Z) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: Z=%b, result=%h",
                         Z, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Z=%b, result=%h",
                         expected_Z, expected_result);
                $display("  Got:      Z=%b, result=%h",
                         Z, result);
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
