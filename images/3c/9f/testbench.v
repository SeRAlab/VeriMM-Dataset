`timescale 1ns/1ps

module a_star_heuristic_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] f;
    reg [3:0] g;
    wire [3:0] h;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    a_star_heuristic dut (
        .f(f),
        .g(g),
        .h(h)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Normal case (f=10, g=4)", test_num);
            f = 4'd10;
            g = 4'd4;
            #1;

            check_outputs(4'd6);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum heuristic (f=15, g=0)", test_num);
            f = 4'd15;
            g = 4'd0;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Result is zero (f=7, g=7)", test_num);
            f = 4'd7;
            g = 4'd7;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Minimum inputs (f=0, g=0)", test_num);
            f = 4'd0;
            g = 4'd0;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Underflow wrapping (f=2, g=5)", test_num);
            f = 4'd2;
            g = 4'd5;
            #1;

            check_outputs(4'd13);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Underflow boundary (f=0, g=1)", test_num);
            f = 4'd0;
            g = 4'd1;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large values (f=15, g=14)", test_num);
            f = 4'd15;
            g = 4'd14;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum underflow distance (f=0, g=15)", test_num);
            f = 4'd0;
            g = 4'd15;
            #1;

            check_outputs(4'd1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("a_star_heuristic Testbench");
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
        input [3:0] expected_h;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_h === (expected_h ^ h ^ expected_h)) begin
                $display("PASS");
                $display("  Outputs: h=%h",
                         h);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: h=%h",
                         expected_h);
                $display("  Got:      h=%h",
                         h);
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
