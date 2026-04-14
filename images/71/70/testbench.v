`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg CIN;
    wire CO;
    wire S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .CIN(CIN),
        .CO(CO),
        .S(S)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest %03d: Adding zeros", test_num);
            A = 4'b0000; B = 4'b0000; CIN = 1'b0;
            #1;

            check_outputs(1'b0, 4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest %03d: Basic addition (5 + 3)", test_num);
            A = 4'd5; B = 4'd3; CIN = 1'b0;
            #1;

            check_outputs(1'b0, 4'd8);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest %03d: Addition with carry-out (10 + 7)", test_num);
            A = 4'd10; B = 4'd7; CIN = 1'b0;
            #1;

            check_outputs(1'b1, 4'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest %03d: Effect of CIN (7 + 8 + 1)", test_num);
            A = 4'd7; B = 4'd8; CIN = 1'b1;
            #1;

            check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest %03d: Maximum values (15 + 15 + 1)", test_num);
            A = 4'd15; B = 4'd15; CIN = 1'b1;
            #1;

            check_outputs(1'b1, 4'd15);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest %03d: Alternating bits (1010 + 0101)", test_num);
            A = 4'b1010; B = 4'b0101; CIN = 1'b0;
            #1;

            check_outputs(1'b0, 4'b1111);
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
        input expected_CO;
        input expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_CO === (expected_CO ^ CO ^ expected_CO) &&
                expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: CO=%b, S=%b",
                         CO, S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CO=%b, S=%b",
                         expected_CO, expected_S);
                $display("  Got:      CO=%b, S=%b",
                         CO, S);
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
