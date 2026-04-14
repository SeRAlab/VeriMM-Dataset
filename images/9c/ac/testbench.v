`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] InputA;
    reg [15:0] InputB;
    reg [15:0] InputC;
    reg [15:0] InputD;
    reg [1:0] Select;
    wire [15:0] Output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .InputA(InputA),
        .InputB(InputB),
        .InputC(InputC),
        .InputD(InputD),
        .Select(Select),
        .Output(Output)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select InputA (00)", test_num);
            Select = 2'b00;
            InputA = 16'hAAAA;
            InputB = 16'hBBBB;
            InputC = 16'hCCCC;
            InputD = 16'hDDDD;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select InputB (01)", test_num);
            Select = 2'b01;
            InputA = 16'h1234;
            InputB = 16'h5678;
            InputC = 16'h9ABC;
            InputD = 16'hDEF0;
            #1;

            check_outputs(16'h5678);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select InputC (10)", test_num);
            Select = 2'b10;
            InputA = 16'h0000;
            InputB = 16'hFFFF;
            InputC = 16'h5555;
            InputD = 16'hAAAA;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select InputD (11)", test_num);
            Select = 2'b11;
            InputA = 16'h1111;
            InputB = 16'h2222;
            InputC = 16'h3333;
            InputD = 16'h4444;
            #1;

            check_outputs(16'h4444);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Edge Case - All Zeros", test_num);
            Select = 2'b00;
            InputA = 16'h0000;
            InputB = 16'hFFFF;
            InputC = 16'hFFFF;
            InputD = 16'hFFFF;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Edge Case - All Ones", test_num);
            Select = 2'b11;
            InputA = 16'h0000;
            InputB = 16'h0000;
            InputC = 16'h0000;
            InputD = 16'hFFFF;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Toggle Select with fixed inputs", test_num);
            InputA = 16'hA001;
            InputB = 16'hB002;
            InputC = 16'hC003;
            InputD = 16'hD004;

            Select = 2'b01;
            #1;

            check_outputs(16'hB002);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Switch back to InputC", test_num);
            InputA = 16'hA001;
            InputB = 16'hB002;
            InputC = 16'hC003;
            InputD = 16'hD004;

            Select = 2'b10;
            #1;

            check_outputs(16'hC003);
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
        input [15:0] expected_Output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Output === (expected_Output ^ Output ^ expected_Output)) begin
                $display("PASS");
                $display("  Outputs: Output=%h",
                         Output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Output=%h",
                         expected_Output);
                $display("  Got:      Output=%h",
                         Output);
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
