`timescale 1ns/1ps

module AStarCostCalculator_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] g;
    reg [31:0] h;
    wire [31:0] f;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    AStarCostCalculator dut (
        .g(g),
        .h(h),
        .f(f)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero inputs", test_num);
        g = 32'd0;
        h = 32'd0;
        #1;

        check_outputs(32'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Simple small values", test_num);
        g = 32'd10;
        h = 32'd25;
        #1;

        check_outputs(32'd35);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Heuristic cost is zero", test_num);
        g = 32'd500;
        h = 32'd0;
        #1;

        check_outputs(32'd500);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Current cost is zero", test_num);
        g = 32'd0;
        h = 32'd1024;
        #1;

        check_outputs(32'd1024);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Large arbitrary values", test_num);
        g = 32'd1234567;
        h = 32'd7654321;
        #1;

        check_outputs(32'd8888888);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Boundary value (Max - 1)", test_num);
        g = 32'hFFFF_FFFE;
        h = 32'd1;
        #1;

        check_outputs(32'hFFFF_FFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum 32-bit values (Overflow behavior check)", test_num);

        g = 32'hFFFF_FFFF;
        h = 32'hFFFF_FFFF;
        #1;

        check_outputs(32'hFFFF_FFFE);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Addition resulting in exact zero (Wrap around)", test_num);
        g = 32'hFFFF_FFFF;
        h = 32'd1;
        #1;

        check_outputs(32'd0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Power of two addition", test_num);
        g = 32'h0000_8000;
        h = 32'h0000_8000;
        #1;

        check_outputs(32'h0001_0000);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating bit patterns", test_num);
        g = 32'hAAAA_AAAA;
        h = 32'h5555_5555;
        #1;

        check_outputs(32'hFFFF_FFFF);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("AStarCostCalculator Testbench");
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
        input [31:0] expected_f;
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
