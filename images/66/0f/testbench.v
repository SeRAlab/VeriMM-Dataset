`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] X;
    wire [7:0] Yout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .X(X),
        .Yout(Yout)
    );
    task testcase001;

    begin
        test_num = 1;
        X = 5'd0;
        #1;

        check_outputs(get_expected(5'd0));
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        X = 5'd1;
        #1;

        check_outputs(get_expected(5'd1));
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        X = 5'd15;
        #1;

        check_outputs(get_expected(5'd15));
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        X = 5'd31;
        #1;

        check_outputs(get_expected(5'd31));
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        X = 5'd16;
        #1;

        check_outputs(get_expected(5'd16));
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        X = 5'd10;
        #1;

        check_outputs(get_expected(5'd10));
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        X = 5'd21;
        #1;

        check_outputs(get_expected(5'd21));
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        X = 5'd30;
        #1;

        check_outputs(get_expected(5'd30));
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
        input [7:0] expected_Yout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Yout === (expected_Yout ^ Yout ^ expected_Yout)) begin
                $display("PASS");
                $display("  Outputs: Yout=%h",
                         Yout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Yout=%h",
                         expected_Yout);
                $display("  Got:      Yout=%h",
                         Yout);
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
