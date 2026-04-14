`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] B;
    wire [7:0] O;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .B(B),
        .O(O)
    );
    task testcase001;

    begin
        test_num = 1;
        B = 4'b0001;
        $display("Test Case %0d: B = %b (Value 1)", test_num, B);
        #1;

        check_outputs(8'b00000010);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        B = 4'b0010;
        $display("Test Case %0d: B = %b (Value 2)", test_num, B);
        #1;

        check_outputs(8'b00000100);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        B = 4'b0100;
        $display("Test Case %0d: B = %b (Value 4)", test_num, B);
        #1;

        check_outputs(8'b00010000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        B = 4'b1000;
        $display("Test Case %0d: B = %b (Value 8)", test_num, B);



        #1;




        check_outputs(8'b00000000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        B = 4'b0000;
        $display("Test Case %0d: B = %b (Value 0 - Invalid)", test_num, B);
        #1;

        check_outputs(8'b00000000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        B = 4'b0011;
        $display("Test Case %0d: B = %b (Value 3 - Invalid)", test_num, B);
        #1;

        check_outputs(8'b00000000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        B = 4'b0110;
        $display("Test Case %0d: B = %b (Value 6 - Invalid)", test_num, B);
        #1;

        check_outputs(8'b00000000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        B = 4'b1111;
        $display("Test Case %0d: B = %b (Value 15 - Invalid)", test_num, B);
        #1;

        check_outputs(8'b00000000);
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
        input [7:0] expected_O;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_O === (expected_O ^ O ^ expected_O)) begin
                $display("PASS");
                $display("  Outputs: O=%h",
                         O);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O=%h",
                         expected_O);
                $display("  Got:      O=%h",
                         O);
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
