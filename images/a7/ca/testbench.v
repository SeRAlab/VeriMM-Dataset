`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] ALUop;
    reg [5:0] FieldFunc;
    wire [3:0] ALUConInput;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUop(ALUop),
        .FieldFunc(FieldFunc),
        .ALUConInput(ALUConInput)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: ALUop=00 (Load/Store)", test_num);
            ALUop = 2'b00;
            FieldFunc = 6'bXXXXXX;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: ALUop=01 (Branch)", test_num);
            ALUop = 2'b01;
            FieldFunc = 6'bXXXXXX;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: R-type ADD (ALUop=10, Func=32)", test_num);
            ALUop = 2'b10;
            FieldFunc = 6'b100000;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: R-type SUB (ALUop=10, Func=34)", test_num);
            ALUop = 2'b10;
            FieldFunc = 6'b100010;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: R-type AND (ALUop=10, Func=36)", test_num);
            ALUop = 2'b10;
            FieldFunc = 6'b100100;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: R-type OR (ALUop=10, Func=37)", test_num);
            ALUop = 2'b10;
            FieldFunc = 6'b100101;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: R-type SLT (ALUop=10, Func=42)", test_num);
            ALUop = 2'b10;
            FieldFunc = 6'b101010;
            #1;

            check_outputs(4'b0111);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: ALUop=11 (Extra/Don't Care case)", test_num);
            ALUop = 2'b11;
            FieldFunc = 6'bXXXXXX;




            #1;





            check_outputs(4'b0110);
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
        input [3:0] expected_ALUConInput;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALUConInput === (expected_ALUConInput ^ ALUConInput ^ expected_ALUConInput)) begin
                $display("PASS");
                $display("  Outputs: ALUConInput=%h",
                         ALUConInput);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUConInput=%h",
                         expected_ALUConInput);
                $display("  Got:      ALUConInput=%h",
                         ALUConInput);
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
