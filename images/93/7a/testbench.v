`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg cin;
    reg [31:0] operand1;
    reg [31:0] operand2;
    wire cout;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cin(cin),
        .operand1(operand1),
        .operand2(operand2),
        .cout(cout),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Zero addition", test_num);
        operand1 = 32'h00000000;
        operand2 = 32'h00000000;
        cin = 0;
        #1;

        check_outputs(0, 32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Carry-in only", test_num);
        operand1 = 32'h00000000;
        operand2 = 32'h00000000;
        cin = 1;
        #1;

        check_outputs(0, 32'h00000001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Simple positive addition", test_num);
        operand1 = 32'h12345678;
        operand2 = 32'h11111111;
        cin = 0;
        #1;

        check_outputs(0, 32'h23456789);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Max result without cout", test_num);
        operand1 = 32'hFFFF_FFFE;
        operand2 = 32'h0000_0001;
        cin = 0;
        #1;

        check_outputs(0, 32'hFFFF_FFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Addition with carry-out", test_num);
        operand1 = 32'hFFFF_FFFF;
        operand2 = 32'h0000_0001;
        cin = 0;
        #1;

        check_outputs(1, 32'h0000_0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Carry-out from cin", test_num);
        operand1 = 32'hFFFF_FFFF;
        operand2 = 32'h0000_0000;
        cin = 1;
        #1;

        check_outputs(1, 32'h0000_0000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Max values with cin", test_num);
        operand1 = 32'hFFFF_FFFF;
        operand2 = 32'hFFFF_FFFF;
        cin = 1;
        #1;

        check_outputs(1, 32'hFFFF_FFFF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: MSB addition", test_num);
        operand1 = 32'h8000_0000;
        operand2 = 32'h8000_0000;
        cin = 0;
        #1;

        check_outputs(1, 32'h0000_0000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Alternating bit patterns", test_num);
        operand1 = 32'h5555_5555;
        operand2 = 32'hAAAA_AAAA;
        cin = 0;
        #1;

        check_outputs(0, 32'hFFFF_FFFF);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Full carry chain", test_num);
        operand1 = 32'h5555_5555;
        operand2 = 32'hAAAA_AAAA;
        cin = 1;
        #1;

        check_outputs(1, 32'h0000_0000);
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
        input expected_cout;
        input [31:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: cout=%b, result=%h",
                         cout, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%b, result=%h",
                         expected_cout, expected_result);
                $display("  Got:      cout=%b, result=%h",
                         cout, result);
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
