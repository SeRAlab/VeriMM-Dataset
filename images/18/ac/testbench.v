`timescale 1ns/1ps

module polynomial_evaluator_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] x;
    wire [7:0] P_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    polynomial_evaluator dut (
        .x(x),
        .P_out(P_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: x = 0", test_num);
        x = 4'd0;
        #1;

        check_outputs(8'd1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: x = 1", test_num);
        x = 4'd1;
        #1;

        check_outputs(8'd3);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: x = 2", test_num);
        x = 4'd2;
        #1;

        check_outputs(8'd7);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: x = 5", test_num);
        x = 4'd5;
        #1;

        check_outputs(8'd31);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: x = 10", test_num);
        x = 4'd10;
        #1;

        check_outputs(8'd111);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: x = 15", test_num);
        x = 4'd15;
        #1;

        check_outputs(8'd241);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("polynomial_evaluator Testbench");
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
        input [7:0] expected_P_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_P_out === (expected_P_out ^ P_out ^ expected_P_out)) begin
                $display("PASS");
                $display("  Outputs: P_out=%h",
                         P_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P_out=%h",
                         expected_P_out);
                $display("  Got:      P_out=%h",
                         P_out);
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
