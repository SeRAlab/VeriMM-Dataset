`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg C;
    reg Cin;
    wire Cout;
    wire [3:0] R;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .Cin(Cin),
        .Cout(Cout),
        .R(R)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        A = 4'd3; B = 4'd4; C = 1'b0; Cin = 1'b0;
        #1;

        check_outputs(1'b0, 4'd7);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        A = 4'd12; B = 4'd8; C = 1'b0; Cin = 1'b0;
        #1;

        check_outputs(1'b1, 4'd4);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        A = 4'd5; B = 4'd2; C = 1'b0; Cin = 1'b1;
        #1;

        check_outputs(1'b0, 4'd8);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        A = 4'hF; B = 4'hF; C = 1'b0; Cin = 1'b1;
        #1;

        check_outputs(1'b1, 4'hF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        A = 4'd10; B = 4'd4; C = 1'b1; Cin = 1'b0;

        #1;


        check_outputs(1'b1, 4'd6);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        A = 4'd4; B = 4'd10; C = 1'b1; Cin = 1'b0;

        #1;


        check_outputs(1'b0, 4'd10);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        A = 4'd7; B = 4'd7; C = 1'b1; Cin = 1'b0;

        #1;


        check_outputs(1'b1, 4'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        A = 4'd10; B = 4'd4; C = 1'b1; Cin = 1'b1;

        #1;


        check_outputs(1'b1, 4'd7);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        A = 4'd0; B = 4'd1; C = 1'b1; Cin = 1'b0;

        #1;


        check_outputs(1'b0, 4'd15);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        A = 4'd5; B = 4'd0; C = 1'b1; Cin = 1'b0;

        #1;


        check_outputs(1'b1, 4'd5);
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
        input expected_Cout;
        input [3:0] expected_R;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Cout === (expected_Cout ^ Cout ^ expected_Cout) &&
                expected_R === (expected_R ^ R ^ expected_R)) begin
                $display("PASS");
                $display("  Outputs: Cout=%b, R=%h",
                         Cout, R);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Cout=%b, R=%h",
                         expected_Cout, expected_R);
                $display("  Got:      Cout=%b, R=%h",
                         Cout, R);
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
