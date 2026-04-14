`timescale 1ns/1ps

module ALU_16bit_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg [3:0] control;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU_16bit dut (
        .A(A),
        .B(B),
        .control(control),
        .result(result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        A = 16'h0005;
        B = 16'h0003;
        control = 4'b0000;
        $display("Test %0d: Addition (5 + 3)", test_num);
        #1;

        check_outputs(16'h0008);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        A = 16'hFFFF;
        B = 16'h0001;
        control = 4'b0000;
        $display("Test %0d: Addition (0xFFFF + 1)", test_num);
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        A = 16'h0010;
        B = 16'h0005;
        control = 4'b0001;
        $display("Test %0d: Subtraction (16 - 5)", test_num);
        #1;

        check_outputs(16'h000B);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        A = 16'h0000;
        B = 16'h0001;
        control = 4'b0001;
        $display("Test %0d: Subtraction (0 - 1)", test_num);
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        A = 16'hAAAA;
        B = 16'hF0F0;
        control = 4'b0010;
        $display("Test %0d: Bitwise AND (AAAA & F0F0)", test_num);
        #1;

        check_outputs(16'hA0A0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        A = 16'h1234;
        B = 16'h0000;
        control = 4'b0010;
        $display("Test %0d: Bitwise AND (1234 & 0000)", test_num);
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        A = 16'h5555;
        B = 16'hAAAA;
        control = 4'b0011;
        $display("Test %0d: Bitwise OR (5555 | AAAA)", test_num);
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        A = 16'h1234;
        B = 16'h4321;
        control = 4'b0011;
        $display("Test %0d: Bitwise OR (1234 | 4321)", test_num);
        #1;

        check_outputs(16'h5335);
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
