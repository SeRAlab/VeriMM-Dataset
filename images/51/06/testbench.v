`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg En;
    reg [1:0] X;
    wire [3:0] Ys;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .En(En),
        .X(X),
        .Ys(Ys)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: En=0, X=00", test_num);
        En = 0;
        X = 2'b00;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: En=0, X=11", test_num);
        En = 0;
        X = 2'b11;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: En=1, X=00", test_num);
        En = 1;
        X = 2'b00;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: En=1, X=01", test_num);
        En = 1;
        X = 2'b01;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: En=1, X=10", test_num);
        En = 1;
        X = 2'b10;
        #1;

        check_outputs(4'b0100);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: En=1, X=11", test_num);
        En = 1;
        X = 2'b11;
        #1;

        check_outputs(4'b1000);
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
        input [3:0] expected_Ys;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Ys === (expected_Ys ^ Ys ^ expected_Ys)) begin
                $display("PASS");
                $display("  Outputs: Ys=%h",
                         Ys);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Ys=%h",
                         expected_Ys);
                $display("  Got:      Ys=%h",
                         Ys);
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
