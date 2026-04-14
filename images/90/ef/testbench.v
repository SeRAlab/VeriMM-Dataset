`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg C;
    wire [3:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .S(S)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        A = 4'd2; B = 4'd3; C = 1'b0;
        $display("Testcase %0d: Basic addition (no overflow)", test_num);
        #1;

        check_outputs(4'd5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        A = 4'd5; B = 4'd6; C = 1'b1;
        $display("Testcase %0d: Addition with carry-in (no overflow)", test_num);
        #1;

        check_outputs(4'd12);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        A = 4'd15; B = 4'd0; C = 1'b0;
        $display("Testcase %0d: Boundary condition (result exactly 15)", test_num);
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        A = 4'd8; B = 4'd7; C = 1'b0;
        $display("Testcase %0d: Boundary condition (result exactly 15)", test_num);
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        A = 4'd10; B = 4'd6; C = 1'b0;
        $display("Testcase %0d: Saturation check (Sum = 16, clamped to 15)", test_num);
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        A = 4'd15; B = 4'd15; C = 1'b1;
        $display("Testcase %0d: Maximum overflow (Sum = 31, clamped to 15)", test_num);
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        A = 4'd0; B = 4'd0; C = 1'b0;
        $display("Testcase %0d: Zero inputs", test_num);
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        A = 4'd0; B = 4'd0; C = 1'b1;
        $display("Testcase %0d: Only carry-in active", test_num);
        #1;

        check_outputs(4'd1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        A = 4'd1; B = 4'd1; C = 1'b1;
        $display("Testcase %0d: Small values with carry-in", test_num);
        #1;

        check_outputs(4'd3);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        A = 4'd14; B = 4'd1; C = 1'b1;
        $display("Testcase %0d: Result exactly 16, clamped to 15", test_num);
        #1;

        check_outputs(4'd15);
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
        input [3:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: S=%h",
                         S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S=%h",
                         expected_S);
                $display("  Got:      S=%h",
                         S);
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
