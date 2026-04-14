`timescale 1ns/1ps

module ALU_16bit_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [3:0] ALU_control;
    reg [15:0] B;
    wire [15:0] ALU_result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU_16bit dut (
        .A(A),
        .ALU_control(ALU_control),
        .B(B),
        .ALU_result(ALU_result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        A = 16'h1234;
        B = 16'h1111;
        ALU_control = 4'b0000;
        #10;
        $display("Test %0d: Addition (1234 + 1111)", test_num);
        #1;

        check_outputs(16'h2345);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        A = 16'hFFFF;
        B = 16'h0001;
        ALU_control = 4'b0000;
        #10;
        $display("Test %0d: Addition Overflow (FFFF + 0001)", test_num);
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        A = 16'h0010;
        B = 16'h0005;
        ALU_control = 4'b0001;
        #10;
        $display("Test %0d: Subtraction (0010 - 0005)", test_num);
        #1;

        check_outputs(16'h000B);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        A = 16'h0000;
        B = 16'h0001;
        ALU_control = 4'b0001;
        #10;
        $display("Test %0d: Subtraction Underflow (0000 - 0001)", test_num);
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        A = 16'hAAAA;
        B = 16'h5555;
        ALU_control = 4'b0010;
        #10;
        $display("Test %0d: Bitwise AND (AAAA & 5555)", test_num);
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        A = 16'hF0F0;
        B = 16'h0F0F;
        ALU_control = 4'b0011;
        #10;
        $display("Test %0d: Bitwise OR (F0F0 | 0F0F)", test_num);
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        A = 16'h1234;
        B = 16'hFFFF;
        ALU_control = 4'b0100;
        #10;
        $display("Test %0d: Bitwise XOR (1234 ^ FFFF)", test_num);
        #1;

        check_outputs(16'hEDCB);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        A = 16'h0001;
        B = 16'd4;
        ALU_control = 4'b0101;
        #10;
        $display("Test %0d: Logical Shift Left (0001 << 4)", test_num);
        #1;

        check_outputs(16'h0010);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        A = 16'h8000;
        B = 16'd1;
        ALU_control = 4'b0101;
        #10;
        $display("Test %0d: Logical Shift Left (8000 << 1)", test_num);
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        A = 16'h0010;
        B = 16'd4;
        ALU_control = 4'b0110;
        #10;
        $display("Test %0d: Logical Shift Right (0010 >> 4)", test_num);
        #1;

        check_outputs(16'h0001);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        A = 16'h0005;
        B = 16'h0010;
        ALU_control = 4'b0111;
        #10;
        $display("Test %0d: Comparison (5 < 16)", test_num);
        #1;

        check_outputs(16'h0001);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        A = 16'h0010;
        B = 16'h0005;
        ALU_control = 4'b0111;
        #10;
        $display("Test %0d: Comparison (16 < 5)", test_num);
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase013;

    begin
        test_num = test_num + 1;
        A = 16'h0010;
        B = 16'h0010;
        ALU_control = 4'b0111;
        #10;
        $display("Test %0d: Comparison (16 < 16)", test_num);
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
        $display("ALU_16bit Testbench");
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
        testcase011();
        testcase012();
        testcase013();
        
        
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
        input [15:0] expected_ALU_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALU_result === (expected_ALU_result ^ ALU_result ^ expected_ALU_result)) begin
                $display("PASS");
                $display("  Outputs: ALU_result=%h",
                         ALU_result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALU_result=%h",
                         expected_ALU_result);
                $display("  Got:      ALU_result=%h",
                         ALU_result);
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
