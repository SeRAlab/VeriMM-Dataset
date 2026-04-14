`timescale 1ns/1ps

module astar_heuristic_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] g;
    reg [7:0] h;
    wire [8:0] f;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    astar_heuristic dut (
        .g(g),
        .h(h),
        .f(f)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Minimum inputs (0 + 0)", test_num);
        g = 8'd0;
        h = 8'd0;
        #1;

        check_outputs(9'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Maximum inputs (255 + 255)", test_num);
        g = 8'd255;
        h = 8'd255;
        #1;

        check_outputs(9'd510);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Mid-range exact power of 2 (128 + 128)", test_num);
        g = 8'd128;
        h = 8'd128;
        #1;

        check_outputs(9'd256);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: G is zero, H is max (0 + 255)", test_num);
        g = 8'd0;
        h = 8'd255;
        #1;

        check_outputs(9'd255);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: G is max, H is zero (255 + 0)", test_num);
        g = 8'd255;
        h = 8'd0;
        #1;

        check_outputs(9'd255);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Small values (10 + 20)", test_num);
        g = 8'd10;
        h = 8'd20;
        #1;

        check_outputs(9'd30);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Large sum exceeding 8-bit range (200 + 100)", test_num);
        g = 8'd200;
        h = 8'd100;
        #1;

        check_outputs(9'd300);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Random arbitrary values (123 + 45)", test_num);
        g = 8'd123;
        h = 8'd45;
        #1;

        check_outputs(9'd168);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("astar_heuristic Testbench");
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
        input [8:0] expected_f;
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
