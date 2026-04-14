`timescale 1ns/1ps

module alu_16bit_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg Ctrl;
    wire [15:0] Result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    alu_16bit dut (
        .A(A),
        .B(B),
        .Ctrl(Ctrl),
        .Result(Result)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Basic Addition (10 + 20)", test_num);
        A = 16'd10;
        B = 16'd20;
        Ctrl = 1'b0;
        #1;

        check_outputs(16'd30);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Addition with Zero", test_num);
        A = 16'h1234;
        B = 16'h0000;
        Ctrl = 1'b0;
        #1;

        check_outputs(16'h1234);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Addition Overflow (0xFFFF + 1)", test_num);
        A = 16'hFFFF;
        B = 16'h0001;
        Ctrl = 1'b0;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Addition of Large Values", test_num);
        A = 16'h7000;
        B = 16'h1000;
        Ctrl = 1'b0;
        #1;

        check_outputs(16'h8000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Basic Subtraction (50 - 20)", test_num);
        A = 16'd50;
        B = 16'd20;
        Ctrl = 1'b1;
        #1;

        check_outputs(16'd30);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Subtraction Resulting in Zero", test_num);
        A = 16'hABCD;
        B = 16'hABCD;
        Ctrl = 1'b1;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Subtraction Resulting in Negative (5 - 10)", test_num);
        A = 16'd5;
        B = 16'd10;
        Ctrl = 1'b1;
        #1;

        check_outputs(16'hFFFB);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Subtraction from Zero (0 - 1)", test_num);
        A = 16'h0000;
        B = 16'h0001;
        Ctrl = 1'b1;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Addition with alternating bits", test_num);
        A = 16'hAAAA;
        B = 16'h5555;
        Ctrl = 1'b0;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Subtraction with Maximum Values", test_num);
        A = 16'hFFFF;
        B = 16'hFFFE;
        Ctrl = 1'b1;
        #1;

        check_outputs(16'h0001);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("alu_16bit Testbench");
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
        input [15:0] expected_Result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Result === (expected_Result ^ Result ^ expected_Result)) begin
                $display("PASS");
                $display("  Outputs: Result=%h",
                         Result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Result=%h",
                         expected_Result);
                $display("  Got:      Result=%h",
                         Result);
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
