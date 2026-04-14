`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg Valid;
    wire [63:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Valid(Valid),
        .C(C)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Positive * Positive", test_num);
        A = 32'sd12;
        B = 32'sd10;
        Valid = 1'b1;
        #1;

        check_outputs(64'sd120);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Negative * Positive", test_num);
        A = -32'sd15;
        B = 32'sd4;
        Valid = 1'b1;
        #1;

        check_outputs(-64'sd60);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Positive * Negative", test_num);
        A = 32'sd20;
        B = -32'sd5;
        Valid = 1'b1;
        #1;

        check_outputs(-64'sd100);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Negative * Negative", test_num);
        A = -32'sd8;
        B = -32'sd7;
        Valid = 1'b1;
        #1;

        check_outputs(64'sd56);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Multiply by Zero", test_num);
        A = 32'sd0;
        B = -32'sd12345;
        Valid = 1'b1;
        #1;

        check_outputs(64'sd0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum Positive Values", test_num);
        A = 32'h7FFFFFFF;
        B = 32'h7FFFFFFF;
        Valid = 1'b1;

        #1;


        check_outputs(64'h3FFFFFFF00000001);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Minimum Negative Values", test_num);
        A = 32'h80000000;
        B = 32'h80000000;
        Valid = 1'b1;

        #1;


        check_outputs(64'h4000000000000000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Mixed Large Values (Min Neg * Max Pos)", test_num);
        A = 32'h80000000;
        B = 32'h7FFFFFFF;
        Valid = 1'b1;

        #1;


        check_outputs(64'hC000000080000000);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Multiplier by -1", test_num);
        A = 32'sd500;
        B = -32'sd1;
        Valid = 1'b1;
        #1;

        check_outputs(-64'sd500);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Valid Signal Low (Disable Output)", test_num);
        A = 32'sd10;
        B = 32'sd10;
        Valid = 1'b0;


        #1;



        check_outputs(64'h0);
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
        input [63:0] expected_C;
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
