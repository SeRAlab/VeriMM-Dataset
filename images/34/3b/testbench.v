`timescale 1ns/1ps

module AStarHeuristic_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] g;
    reg [3:0] h;
    wire [3:0] f;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    AStarHeuristic dut (
        .g(g),
        .h(h),
        .f(f)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All zeros", test_num);
        g = 4'd0;
        h = 4'd0;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Simple addition without overflow", test_num);
        g = 4'd3;
        h = 4'd4;
        #1;

        check_outputs(4'd7);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Max result without overflow", test_num);
        g = 4'd7;
        h = 4'd8;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: g is max, h is zero", test_num);
        g = 4'd15;
        h = 4'd0;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Minimum overflow (15 + 1)", test_num);
        g = 4'd15;
        h = 4'd1;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Mid-range overflow (10 + 10)", test_num);
        g = 4'd10;
        h = 4'd10;
        #1;

        check_outputs(4'd4);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum overflow (15 + 15)", test_num);
        g = 4'd15;
        h = 4'd15;
        #1;

        check_outputs(4'd14);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Power of two sum (8 + 8)", test_num);
        g = 4'd8;
        h = 4'd8;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternate values", test_num);
        g = 4'b1010;
        h = 4'b0101;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Smallest increment", test_num);
        g = 4'd1;
        h = 4'd1;
        #1;

        check_outputs(4'd2);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("AStarHeuristic Testbench");
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
        input [3:0] expected_f;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_f === (expected_f ^ f ^ expected_f)) begin
                $display("PASS");
                $display("  Outputs: f=%h",
                         f);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: f=%h",
                         expected_f);
                $display("  Got:      f=%h",
                         f);
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
