`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [17:0] input1;
    reg [17:0] input2;
    reg [1:0] operation;
    wire carryOutAdder;
    wire [17:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input1(input1),
        .input2(input2),
        .operation(operation),
        .carryOutAdder(carryOutAdder),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bitwise AND", test_num);
            input1 = 18'h2AAAA;
            input2 = 18'h3FFFF;
            operation = 2'b00;

            #1;


            check_outputs(1'b0, 18'h2AAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bitwise OR", test_num);
            input1 = 18'h15555;
            input2 = 18'h2AAAA;
            operation = 2'b01;

            #1;


            check_outputs(1'b0, 18'h3FFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition (No Carry)", test_num);
            input1 = 18'h01234;
            input2 = 18'h04321;
            operation = 2'b10;

            #1;


            check_outputs(1'b0, 18'h05555);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition (With Carry)", test_num);
            input1 = 18'h30000;
            input2 = 18'h10000;
            operation = 2'b10;


            #1;



            check_outputs(1'b1, 18'h00000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bitwise XOR", test_num);
            input1 = 18'h12345;
            input2 = 18'h12345;
            operation = 2'b11;

            #1;


            check_outputs(1'b0, 18'h00000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bitwise XOR Inverse", test_num);
            input1 = 18'h3FFFF;
            input2 = 18'h00000;
            operation = 2'b11;

            #1;


            check_outputs(1'b0, 18'h3FFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition Boundary (Max Values)", test_num);
            input1 = 18'h3FFFF;
            input2 = 18'h3FFFF;
            operation = 2'b10;


            #1;



            check_outputs(1'b1, 18'h3FFFE);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bitwise AND Zero", test_num);
            input1 = 18'h3FFFF;
            input2 = 18'h00000;
            operation = 2'b00;
            #1;

            check_outputs(1'b0, 18'h00000);
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
        input expected_carryOutAdder;
        input [17:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_carryOutAdder === (expected_carryOutAdder ^ carryOutAdder ^ expected_carryOutAdder) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: carryOutAdder=%b, result=%h",
                         carryOutAdder, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carryOutAdder=%b, result=%h",
                         expected_carryOutAdder, expected_result);
                $display("  Got:      carryOutAdder=%b, result=%h",
                         carryOutAdder, result);
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
