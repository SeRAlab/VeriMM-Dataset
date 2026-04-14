`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg Rst;
    wire Cout;
    wire [3:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Rst(Rst),
        .Cout(Cout),
        .S(S)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Reset Active - Checking if outputs are zeroed", test_num);
        A = 4'hF; B = 4'hF; Rst = 1;
        #10;
        #1;

        check_outputs(1'b0, 4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Addition without carry (2 + 3)", test_num);
        Rst = 1; #5; Rst = 0;
        A = 4'd2; B = 4'd3;
        #10;
        #1;

        check_outputs(1'b0, 4'd5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Boundary addition (8 + 8)", test_num);
        Rst = 1; #5; Rst = 0;
        A = 4'd8; B = 4'd8;
        #10;
        #1;

        check_outputs(1'b1, 4'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Addition with carry (10 + 7)", test_num);
        Rst = 1; #5; Rst = 0;
        A = 4'd10; B = 4'd7;
        #10;
        #1;

        check_outputs(1'b1, 4'd1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Maximum values (15 + 15)", test_num);
        Rst = 1; #5; Rst = 0;
        A = 4'hF; B = 4'hF;
        #10;
        #1;

        check_outputs(1'b1, 4'hE);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Zero addition (0 + 0)", test_num);
        Rst = 1; #5; Rst = 0;
        A = 4'h0; B = 4'h0;
        #10;
        #1;

        check_outputs(1'b0, 4'h0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Sum of 15 (7 + 8)", test_num);
        Rst = 1; #5; Rst = 0;
        A = 4'd7; B = 4'd8;
        #10;
        #1;

        check_outputs(1'b0, 4'hF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %03d: Reset after operation", test_num);

        Rst = 0; A = 4'h5; B = 4'h5;
        #5;

        Rst = 1;
        #10;
        #1;

        check_outputs(1'b0, 4'h0);
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
        input [3:0] expected_S;
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
