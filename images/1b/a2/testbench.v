`timescale 1ns/1ps

module ALU_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [2:0] ctrl;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU_8bit dut (
        .A(A),
        .B(B),
        .ctrl(ctrl),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Addition (5 + 10)", test_num);
        A = 8'd5; B = 8'd10; ctrl = 3'b000;
        #1;

        check_outputs(8'd15);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Addition Overflow (255 + 1)", test_num);
        A = 8'hFF; B = 8'h01; ctrl = 3'b000;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Subtraction (20 - 5)", test_num);
        A = 8'd20; B = 8'd5; ctrl = 3'b001;
        #1;

        check_outputs(8'd15);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Subtraction Underflow (5 - 10)", test_num);
        A = 8'd5; B = 8'd10; ctrl = 3'b001;
        #1;

        check_outputs(8'hFB);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Bitwise AND (F0 & CC)", test_num);
        A = 8'hF0; B = 8'hCC; ctrl = 3'b010;
        #1;

        check_outputs(8'hC0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Bitwise OR (F0 | 0F)", test_num);
        A = 8'hF0; B = 8'h0F; ctrl = 3'b011;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Bitwise XOR (AA ^ 55)", test_num);
        A = 8'hAA; B = 8'h55; ctrl = 3'b100;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %03d: Bitwise XOR (FF ^ FF)", test_num);
        A = 8'hFF; B = 8'hFF; ctrl = 3'b100;
        #1;

        check_outputs(8'h00);
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
