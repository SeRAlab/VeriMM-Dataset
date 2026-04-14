`timescale 1ns/1ps

module astar_heuristic_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] g;
    reg [7:0] h;
    wire [7:0] f;

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
            test_num = 1;
            g = 8'd0;
            h = 8'd0;
            $display("Test %0d: Zero Case (g=0, h=0)", test_num);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            g = 8'd45;
            h = 8'd0;
            $display("Test %0d: Identity Case g (g=45, h=0)", test_num);
            #1;

            check_outputs(8'd45);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            g = 8'd0;
            h = 8'd128;
            $display("Test %0d: Identity Case h (g=0, h=128)", test_num);
            #1;

            check_outputs(8'd128);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            g = 8'd10;
            h = 8'd20;
            $display("Test %0d: Simple Addition (g=10, h=20)", test_num);
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            g = 8'd127;
            h = 8'd128;
            $display("Test %0d: Boundary Sum (g=127, h=128, f=255)", test_num);
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            g = 8'd200;
            h = 8'd100;
            $display("Test %0d: Overflow Case (g=200, h=100, f=300 mod 256 = 44)", test_num);
            #1;

            check_outputs(8'd44);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            g = 8'd255;
            h = 8'd1;
            $display("Test %0d: Exact Overflow Boundary (g=255, h=1, f=256 mod 256 = 0)", test_num);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            g = 8'd255;
            h = 8'd255;
            $display("Test %0d: Maximum Values (g=255, h=255, f=510 mod 256 = 254)", test_num);
            #1;

            check_outputs(8'd254);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            g = 8'hAA;
            h = 8'h55;
            $display("Test %0d: Hex Pattern (g=AA, h=55)", test_num);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            g = 8'd86;
            h = 8'd34;
            $display("Test %0d: Random Mid Range (g=86, h=34)", test_num);
            #1;

            check_outputs(8'd120);
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
        input [7:0] expected_f;
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
