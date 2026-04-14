`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg C;
    reg [3:0] I;
    wire [4:0] O;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .C(C),
        .I(I),
        .O(O)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: C=0, I=4'b0000", test_num);
        C = 1'b0;
        I = 4'b0000;
        #1;

        check_outputs(5'b00000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: C=1, I=4'b0000", test_num);
        C = 1'b1;
        I = 4'b0000;
        #1;

        check_outputs(5'b10000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: C=0, I=4'b1111", test_num);
        C = 1'b0;
        I = 4'b1111;
        #1;

        check_outputs(5'b01111);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: C=1, I=4'b1111", test_num);
        C = 1'b1;
        I = 4'b1111;
        #1;

        check_outputs(5'b11111);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: C=0, I=4'b1010", test_num);
        C = 1'b0;
        I = 4'b1010;
        #1;

        check_outputs(5'b01010);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: C=1, I=4'b0101", test_num);
        C = 1'b1;
        I = 4'b0101;
        #1;

        check_outputs(5'b10101);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: C=1, I=4'b1001", test_num);
        C = 1'b1;
        I = 4'b1001;
        #1;

        check_outputs(5'b11001);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: C=0, I=4'b0110", test_num);
        C = 1'b0;
        I = 4'b0110;
        #1;

        check_outputs(5'b00110);
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
        input [4:0] expected_O;
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
