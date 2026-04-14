`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg CTRL;
    wire [3:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .CTRL(CTRL),
        .C(C)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: CTRL=0, Standard Addition (Small values)", test_num);
        A = 4'd2; B = 4'd3; CTRL = 1'b0;
        #1;

        check_outputs(4'd5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: CTRL=0, Standard Addition (Maximum sum, no overflow)", test_num);
        A = 4'd7; B = 4'd8; CTRL = 1'b0;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: CTRL=0, Standard Addition (Overflow condition)", test_num);
        A = 4'd10; B = 4'd10; CTRL = 1'b0;
        #1;

        check_outputs(4'd4);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: CTRL=0, Adding Zero", test_num);
        A = 4'd15; B = 4'd0; CTRL = 1'b0;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: CTRL=1, Upper Bits Addition (No LSB influence)", test_num);

        A = 4'b0010; B = 4'b0100; CTRL = 1'b1;
        #1;

        check_outputs(4'd3);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: CTRL=1, Verifying LSB is discarded", test_num);

        A = 4'b0011; B = 4'b0101; CTRL = 1'b1;
        #1;

        check_outputs(4'd3);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: CTRL=1, Upper Bits Addition (Max values)", test_num);

        A = 4'b1110; B = 4'b1110; CTRL = 1'b1;
        #1;

        check_outputs(4'd14);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: CTRL=1, Discarding LSB of all ones", test_num);

        A = 4'b1111; B = 4'b1111; CTRL = 1'b1;
        #1;

        check_outputs(4'd14);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: CTRL=1, Adding with zero in upper bits", test_num);

        A = 4'b1011; B = 4'b0001; CTRL = 1'b1;
        #1;

        check_outputs(4'd5);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Switching CTRL mode on same inputs", test_num);
        A = 4'b0111; B = 4'b0011;

        CTRL = 1'b0;
        #1;
        $display("  Sub-test CTRL=0");
        if (C === 4'd10) pass_count = pass_count + 1; else fail_count = fail_count + 1;

        CTRL = 1'b1;
        #1;
        $display("  Sub-test CTRL=1");
        #1;

        check_outputs(4'd4);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [3:0] expected_C;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C)) begin
                $display("PASS");
                $display("  Outputs: C=%h",
                         C);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h",
                         expected_C);
                $display("  Got:      C=%h",
                         C);
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
