`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] Data_i;
    reg [1:0] Round_Type_i;
    reg Sign_Result_i;
    wire Round_Flag_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Data_i(Data_i),
        .Round_Type_i(Round_Type_i),
        .Sign_Result_i(Sign_Result_i),
        .Round_Flag_o(Round_Flag_o)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            Data_i = 2'b10; Round_Type_i = 2'b00; Sign_Result_i = 1'b0;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            Data_i = 2'b01; Round_Type_i = 2'b00; Sign_Result_i = 1'b1;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            Data_i = 2'b11; Round_Type_i = 2'b01; Sign_Result_i = 1'b0;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            Data_i = 2'b01; Round_Type_i = 2'b10; Sign_Result_i = 1'b0;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            Data_i = 2'b11; Round_Type_i = 2'b10; Sign_Result_i = 1'b1;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            Data_i = 2'b01; Round_Type_i = 2'b11; Sign_Result_i = 1'b1;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            Data_i = 2'b10; Round_Type_i = 2'b11; Sign_Result_i = 1'b0;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            Data_i = 2'b00; Round_Type_i = 2'b10; Sign_Result_i = 1'b0;
            #10;
            #1;

            check_outputs(1'b0);
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
        input expected_Round_Flag_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Round_Flag_o === (expected_Round_Flag_o ^ Round_Flag_o ^ expected_Round_Flag_o)) begin
                $display("PASS");
                $display("  Outputs: Round_Flag_o=%b",
                         Round_Flag_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Round_Flag_o=%b",
                         expected_Round_Flag_o);
                $display("  Got:      Round_Flag_o=%b",
                         Round_Flag_o);
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
