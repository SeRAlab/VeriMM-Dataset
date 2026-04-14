`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg reset;
    wire equal;
    wire greater_than;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .reset(reset),
        .equal(equal),
        .greater_than(greater_than)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Equal comparison (A == B)", test_num);
            reset = 1; A = 16'h0000; B = 16'hFFFF; #10;
            reset = 0; A = 16'h1234; B = 16'h1234;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Greater than comparison (A > B)", test_num);
            reset = 1; A = 0; B = 0; #10;
            reset = 0; A = 16'h0005; B = 16'h0002;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Less than comparison (A < B)", test_num);
            reset = 1; A = 0; B = 0; #10;
            reset = 0; A = 16'h0002; B = 16'h0005;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum values equal (A = B = 0xFFFF)", test_num);
            reset = 1; A = 0; B = 0; #10;
            reset = 0; A = 16'hFFFF; B = 16'hFFFF;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum value vs Minimum value (A > B)", test_num);
            reset = 1; A = 0; B = 0; #10;
            reset = 0; A = 16'hFFFF; B = 16'h0000;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Minimum value vs Maximum value (A < B)", test_num);
            reset = 1; A = 0; B = 0; #10;
            reset = 0; A = 16'h0000; B = 16'hFFFF;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset behavior active", test_num);
            reset = 1; A = 16'h5555; B = 16'h5555;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset override during comparison", test_num);
            reset = 0; A = 16'hAAAA; B = 16'h0000; #10;
            reset = 1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Close values (A > B by 1)", test_num);
            reset = 1; A = 0; B = 0; #10;
            reset = 0; A = 16'h8001; B = 16'h8000;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Close values (A < B by 1)", test_num);
            reset = 1; A = 0; B = 0; #10;
            reset = 0; A = 16'h7FFE; B = 16'h7FFF;
            #1;

            check_outputs(1'b0, 1'b0);
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
        input expected_equal;
        input expected_greater_than;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_equal === (expected_equal ^ equal ^ expected_equal) &&
                expected_greater_than === (expected_greater_than ^ greater_than ^ expected_greater_than)) begin
                $display("PASS");
                $display("  Outputs: equal=%b, greater_than=%b",
                         equal, greater_than);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: equal=%b, greater_than=%b",
                         expected_equal, expected_greater_than);
                $display("  Got:      equal=%b, greater_than=%b",
                         equal, greater_than);
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
