`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [3:0] C;
    reg Select;
    wire [3:0] Sum;
    wire [7:0] priority_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .Select(Select),
        .Sum(Sum),
        .priority_out(priority_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;

        A = 0; B = 0; C = 0; Select = 0;
        #5;
        A = 4'd5; B = 4'd3; Select = 1; C = 4'b0000;
        #1;

        check_outputs(4'h0, 8'b0000_0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        A = 0; B = 0; C = 0; Select = 0;
        #5;
        A = 4'd5; B = 4'd3; Select = 0; C = 4'b0001;
        #1;

        check_outputs(4'd8, 8'b0000_0001);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        A = 0; B = 0; C = 0; Select = 0;
        #5;
        A = 4'd12; B = 4'd10; Select = 0; C = 4'b0010;
        #1;

        check_outputs(4'd6, 8'b0000_0010);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        A = 0; B = 0; C = 0; Select = 0;
        #5;
        A = 4'd1; B = 4'd1; Select = 0; C = 4'b1000;
        #1;

        check_outputs(4'd2, 8'b0000_1000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        A = 0; B = 0; C = 0; Select = 0;
        #5;
        A = 4'd0; B = 4'd0; Select = 0; C = 4'b1011;
        #1;

        check_outputs(4'd0, 8'b0000_1000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        A = 0; B = 0; C = 0; Select = 0;
        #5;
        A = 4'd2; B = 4'd2; Select = 0; C = 4'b0111;
        #1;

        check_outputs(4'd4, 8'b0000_0100);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        A = 0; B = 0; C = 0; Select = 0;
        #5;
        A = 4'd7; B = 4'd1; Select = 0; C = 4'b0011;
        #1;

        check_outputs(4'd8, 8'b0000_0010);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        A = 0; B = 0; C = 0; Select = 0;
        #5;
        A = 4'hf; B = 4'hf; Select = 1; C = 4'b1111;
        #1;

        check_outputs(4'h0, 8'b0000_1000);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        A = 0; B = 0; C = 0; Select = 0;
        #5;
        A = 4'hf; B = 4'hf; Select = 0; C = 4'b0001;
        #1;

        check_outputs(4'd14, 8'b0000_0001);
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
        input [3:0] expected_Sum;
        input [7:0] expected_priority_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Sum === (expected_Sum ^ Sum ^ expected_Sum) &&
                expected_priority_out === (expected_priority_out ^ priority_out ^ expected_priority_out)) begin
                $display("PASS");
                $display("  Outputs: Sum=%h, priority_out=%h",
                         Sum, priority_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Sum=%h, priority_out=%h",
                         expected_Sum, expected_priority_out);
                $display("  Got:      Sum=%h, priority_out=%h",
                         Sum, priority_out);
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
