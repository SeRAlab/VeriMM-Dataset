`timescale 1ns/1ps

module alu_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [2:0] control;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    alu_8bit dut (
        .A(A),
        .B(B),
        .control(control),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Addition (15 + 27)", test_num);
        A = 8'd15; B = 8'd27; control = 3'b000;
        #1;

        check_outputs(8'd42);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Subtraction (50 - 20)", test_num);
        A = 8'd50; B = 8'd20; control = 3'b001;
        #1;

        check_outputs(8'd30);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Bitwise AND (0xAA & 0xF0)", test_num);
        A = 8'hAA; B = 8'hF0; control = 3'b010;
        #1;

        check_outputs(8'hA0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Bitwise OR (0x55 | 0x0F)", test_num);
        A = 8'h55; B = 8'h0F; control = 3'b011;
        #1;

        check_outputs(8'h5F);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Bitwise XOR (0xFF ^ 0xAA)", test_num);
        A = 8'hFF; B = 8'hAA; control = 3'b100;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Comparison (10 < 20)", test_num);
        A = 8'd10; B = 8'd20; control = 3'b101;
        #1;

        check_outputs(8'd1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Shift Left (0x07 << 1)", test_num);
        A = 8'h07; B = 8'h00; control = 3'b110;
        #1;

        check_outputs(8'h0E);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Shift Right (0x80 >> 1)", test_num);
        A = 8'h80; B = 8'h00; control = 3'b111;
        #1;

        check_outputs(8'h40);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("alu_8bit Testbench");
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
