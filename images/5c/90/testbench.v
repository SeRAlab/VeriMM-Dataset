`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] A;
    reg [2:0] B;
    wire Cout;
    wire [2:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Cout(Cout),
        .S(S)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 0 + 0", test_num);
        A = 3'b000;
        B = 3'b000;
        #1;

        check_outputs(1'b0, 3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 1 + 2", test_num);
        A = 3'b001;
        B = 3'b010;
        #1;

        check_outputs(1'b0, 3'b011);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 3 + 4", test_num);
        A = 3'b011;
        B = 3'b100;
        #1;

        check_outputs(1'b0, 3'b111);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 4 + 4 (Result 8)", test_num);
        A = 3'b100;
        B = 3'b100;
        #1;

        check_outputs(1'b1, 3'b000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 7 + 1 (Result 8)", test_num);
        A = 3'b111;
        B = 3'b001;
        #1;

        check_outputs(1'b1, 3'b000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 7 + 7 (Result 14)", test_num);
        A = 3'b111;
        B = 3'b111;
        #1;

        check_outputs(1'b1, 3'b110);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 5 + 2", test_num);
        A = 3'b101;
        B = 3'b010;
        #1;

        check_outputs(1'b0, 3'b111);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 6 + 3 (Result 9)", test_num);
        A = 3'b110;
        B = 3'b011;
        #1;

        check_outputs(1'b1, 3'b001);
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
        input expected_Cout;
        input [2:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Cout === (expected_Cout ^ Cout ^ expected_Cout) &&
                expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: Cout=%b, S=%h",
                         Cout, S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Cout=%b, S=%h",
                         expected_Cout, expected_S);
                $display("  Got:      Cout=%b, S=%h",
                         Cout, S);
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
