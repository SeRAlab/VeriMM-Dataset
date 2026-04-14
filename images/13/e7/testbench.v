`timescale 1ns/1ps

module dwt_haar_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] x;
    wire [3:0] approx;
    wire [3:0] detail;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dwt_haar dut (
        .x(x),
        .approx(approx),
        .detail(detail)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input Pair (0, 0)", test_num);
            x = 4'b0000;
            #1;

            check_outputs(4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input Pair (3, 3)", test_num);
            x = 4'b1111;
            #1;

            check_outputs(4'h3, 4'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input Pair (3, 0)", test_num);
            x = 4'b1100;
            #1;

            check_outputs(4'h1, 4'h3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input Pair (0, 3)", test_num);
            x = 4'b0011;
            #1;

            check_outputs(4'h1, 4'hD);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input Pair (3, 1)", test_num);
            x = 4'b1101;
            #1;

            check_outputs(4'h2, 4'h2);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input Pair (1, 3)", test_num);
            x = 4'b0111;
            #1;

            check_outputs(4'h2, 4'hE);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input Pair (2, 1)", test_num);
            x = 4'b1001;
            #1;

            check_outputs(4'h1, 4'h1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input Pair (1, 2)", test_num);
            x = 4'b0110;
            #1;

            check_outputs(4'h1, 4'hF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dwt_haar Testbench");
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
        input [3:0] expected_approx;
        input [3:0] expected_detail;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_approx === (expected_approx ^ approx ^ expected_approx) &&
                expected_detail === (expected_detail ^ detail ^ expected_detail)) begin
                $display("PASS");
                $display("  Outputs: approx=%h, detail=%h",
                         approx, detail);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: approx=%h, detail=%h",
                         expected_approx, expected_detail);
                $display("  Got:      approx=%h, detail=%h",
                         approx, detail);
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
