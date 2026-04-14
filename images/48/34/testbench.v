`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg cin;
    reg [3:0] v;
    wire [3:0] s2;
    wire z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cin(cin),
        .v(v),
        .s2(s2),
        .z(z)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: v=0, cin=0", test_num);
            v = 4'd0; cin = 1'b0;
            #1;

            check_outputs(4'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: v=5, cin=0", test_num);
            v = 4'd5; cin = 1'b0;
            #1;

            check_outputs(4'd5, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: v=9, cin=0", test_num);
            v = 4'd9; cin = 1'b0;
            #1;

            check_outputs(4'd9, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: v=10, cin=0 (Boundary v > 9)", test_num);
            v = 4'd10; cin = 1'b0;
            #1;

            check_outputs(4'd0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: v=15, cin=0", test_num);
            v = 4'd15; cin = 1'b0;
            #1;

            check_outputs(4'd5, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: v=0, cin=1", test_num);
            v = 4'd0; cin = 1'b1;
            #1;

            check_outputs(4'd6, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: v=3, cin=1", test_num);
            v = 4'd3; cin = 1'b1;
            #1;

            check_outputs(4'd9, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: v=4, cin=1 (Boundary s2 result 10)", test_num);
            v = 4'd4; cin = 1'b1;
            #1;

            check_outputs(4'd10, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: v=9, cin=1", test_num);
            v = 4'd9; cin = 1'b1;
            #1;

            check_outputs(4'd15, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: v=10, cin=1 (v > 9 AND cin=1)", test_num);
            v = 4'd10; cin = 1'b1;
            #1;

            check_outputs(4'd6, 1'b1);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: v=15, cin=1", test_num);
            v = 4'd15; cin = 1'b1;
            #1;

            check_outputs(4'd11, 1'b1);
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
        testcase011();
        
        
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
        input [3:0] expected_s2;
        input expected_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_s2 === (expected_s2 ^ s2 ^ expected_s2) &&
                expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: s2=%h, z=%b",
                         s2, z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: s2=%h, z=%b",
                         expected_s2, expected_z);
                $display("  Got:      s2=%h, z=%b",
                         s2, z);
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
