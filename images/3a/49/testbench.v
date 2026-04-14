`timescale 1ns/1ps

module matrix_inverse_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    wire [15:0] inv;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    matrix_inverse dut (
        .a(a),
        .inv(inv)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Identity Matrix", test_num);
        a = 16'h1001;
        #1;

        check_outputs(16'h1001);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Upper Triangular (det=1)", test_num);
        a = 16'h1201;
        #1;

        check_outputs(16'h1E01);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Lower Triangular (det=1)", test_num);
        a = 16'h1031;
        #1;

        check_outputs(16'h10D1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: General Matrix (det=-1)", test_num);
        a = 16'h1211;
        #1;

        check_outputs(16'hF21F);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Negative Inputs (det=1)", test_num);
        a = 16'hFF10;
        #1;

        check_outputs(16'h01FF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Permutation Matrix", test_num);
        a = 16'h0110;
        #1;

        check_outputs(16'h0110);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("matrix_inverse Testbench");
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
        input [15:0] expected_inv;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_inv === (expected_inv ^ inv ^ expected_inv)) begin
                $display("PASS");
                $display("  Outputs: inv=%h",
                         inv);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: inv=%h",
                         expected_inv);
                $display("  Got:      inv=%h",
                         inv);
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
