`timescale 1ns/1ps

module ALU_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg [3:0] control;
    wire Z;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU dut (
        .A(A),
        .B(B),
        .control(control),
        .Z(Z),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Addition - Basic (5 + 10)", test_num);
        A = 16'h0005;
        B = 16'h000A;
        control = 4'b0000;
        #1;

        check_outputs(1'b0, 16'h000F);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Addition - Overflow to Zero", test_num);
        A = 16'hFFFF;
        B = 16'h0001;
        control = 4'b0000;
        #1;

        check_outputs(1'b1, 16'h0000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Subtraction - Basic (20 - 5)", test_num);
        A = 16'h0014;
        B = 16'h0005;
        control = 4'b0001;
        #1;

        check_outputs(1'b0, 16'h000F);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Subtraction - Result Zero", test_num);
        A = 16'hABCD;
        B = 16'hABCD;
        control = 4'b0001;
        #1;

        check_outputs(1'b1, 16'h0000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Subtraction - Wrap around (0 - 1)", test_num);
        A = 16'h0000;
        B = 16'h0001;
        control = 4'b0001;
        #1;

        check_outputs(1'b0, 16'hFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Bitwise AND - Basic", test_num);
        A = 16'hF0F0;
        B = 16'hFF00;
        control = 4'b0010;
        #1;

        check_outputs(1'b0, 16'hF000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Bitwise AND - Result Zero", test_num);
        A = 16'hAAAA;
        B = 16'h5555;
        control = 4'b0010;
        #1;

        check_outputs(1'b1, 16'h0000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Bitwise OR - Basic", test_num);
        A = 16'h1234;
        B = 16'h4321;
        control = 4'b0011;
        #1;

        check_outputs(1'b0, 16'h5375);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Bitwise OR - Result All Ones", test_num);
        A = 16'hAAAA;
        B = 16'h5555;
        control = 4'b0011;
        #1;

        check_outputs(1'b0, 16'hFFFF);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Bitwise OR - Result Zero", test_num);
        A = 16'h0000;
        B = 16'h0000;
        control = 4'b0011;
        #1;

        check_outputs(1'b1, 16'h0000);
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
        input [15:0] expected_result;
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
