`timescale 1ns/1ps

module ALU_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg [2:0] ctrl;
    wire carry_out;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU dut (
        .A(A),
        .B(B),
        .ctrl(ctrl),
        .carry_out(carry_out),
        .result(result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Addition (No Carry Out)", test_num);
        A = 32'h0000_0005;
        B = 32'h0000_000A;
        ctrl = 3'd0;
        #1;

        check_outputs(1'b0, 32'h0000_000F);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Addition (With Carry Out)", test_num);
        A = 32'hFFFF_FFFF;
        B = 32'h0000_0001;
        ctrl = 3'd0;
        #1;

        check_outputs(1'b1, 32'h0000_0000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Subtraction (Positive Result)", test_num);
        A = 32'h0000_0014;
        B = 32'h0000_0006;
        ctrl = 3'd1;


        #1;



        check_outputs(1'b1, 32'h0000_000E);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Subtraction (Negative Result)", test_num);
        A = 32'h0000_0005;
        B = 32'h0000_000A;
        ctrl = 3'd1;

        #1;


        check_outputs(1'b0, 32'hFFFF_FFFB);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bitwise AND", test_num);
        A = 32'hF0F0_AAAA;
        B = 32'h0F0F_FFFF;
        ctrl = 3'd2;
        #1;

        check_outputs(1'b0, 32'h0000_AAAA);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bitwise OR", test_num);
        A = 32'h1234_0000;
        B = 32'h0000_5678;
        ctrl = 3'd3;
        #1;

        check_outputs(1'b0, 32'h1234_5678);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bitwise XOR", test_num);
        A = 32'hFFFF_FFFF;
        B = 32'h1234_5678;
        ctrl = 3'd4;
        #1;

        check_outputs(1'b0, 32'hEDCB_A987);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Addition (Large Values)", test_num);
        A = 32'h7FFFFFFF;
        B = 32'h7FFFFFFF;
        ctrl = 3'd0;
        #1;

        check_outputs(1'b0, 32'hFFFFFFFE);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Subtraction (Result Zero)", test_num);
        A = 32'hDEAD_BEEF;
        B = 32'hDEAD_BEEF;
        ctrl = 3'd1;
        #1;

        check_outputs(1'b1, 32'h0000_0000);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bitwise AND (Zero result)", test_num);
        A = 32'hAAAA_AAAA;
        B = 32'h5555_5555;
        ctrl = 3'd2;
        #1;

        check_outputs(1'b0, 32'h0000_0000);
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
        input expected_carry_out;
        input [31:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_carry_out === (expected_carry_out ^ carry_out ^ expected_carry_out) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: carry_out=%b, result=%h",
                         carry_out, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry_out=%b, result=%h",
                         expected_carry_out, expected_result);
                $display("  Got:      carry_out=%b, result=%h",
                         carry_out, result);
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
