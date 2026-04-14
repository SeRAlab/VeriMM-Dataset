`timescale 1ns/1ps

module ALU_32bit_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [2:0] ALU_op;
    reg [31:0] B;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU_32bit dut (
        .A(A),
        .ALU_op(ALU_op),
        .B(B),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 32'd15;
        B = 32'd27;
        ALU_op = 3'b000;
        $display("Test %0d: Addition (15 + 27)", test_num);
        #1;

        check_outputs(32'd42);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 32'd100;
        B = 32'd40;
        ALU_op = 3'b001;
        $display("Test %0d: Subtraction (100 - 40)", test_num);
        #1;

        check_outputs(32'd60);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 32'hAAAA_AAAA;
        B = 32'hFFFF_0000;
        ALU_op = 3'b010;
        $display("Test %0d: Bitwise AND", test_num);
        #1;

        check_outputs(32'hAAAA_0000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 32'h5555_5555;
        B = 32'h0000_FFFF;
        ALU_op = 3'b011;
        $display("Test %0d: Bitwise OR", test_num);
        #1;

        check_outputs(32'h5555_FFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 32'h1234_5678;
        B = 32'h1234_5678;
        ALU_op = 3'b100;
        $display("Test %0d: Bitwise XOR (Self)", test_num);
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 32'hFFFF_FFFF;
        B = 32'h0000_0001;
        ALU_op = 3'b000;
        $display("Test %0d: Addition Wrap-around", test_num);
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 32'h0000_0000;
        B = 32'h0000_0001;
        ALU_op = 3'b001;
        $display("Test %0d: Subtraction Negative Result", test_num);
        #1;

        check_outputs(32'hFFFF_FFFF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 32'hDEAD_BEEF;
        B = 32'h0000_0000;
        ALU_op = 3'b100;
        $display("Test %0d: XOR with Zero", test_num);
        #1;

        check_outputs(32'hDEAD_BEEF);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ALU_32bit Testbench");
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
