`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] default_color;
    reg [4:0] hit_times;
    reg is_hit;
    reg [8:0] rgb_bullet;
    wire [8:0] rgb_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .default_color(default_color),
        .hit_times(hit_times),
        .is_hit(is_hit),
        .rgb_bullet(rgb_bullet),
        .rgb_out(rgb_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bullet has not been hit yet (hit_times=0, is_hit=0)", test_num);
            rgb_bullet = 9'h1FF;
            default_color = 9'h000;
            hit_times = 5'd0;
            is_hit = 1'b0;
            #1;

            check_outputs(9'h1FF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: hit_times is 4 but is_hit is 0", test_num);
            rgb_bullet = 9'h1AA;
            default_color = 9'h055;
            hit_times = 5'd4;
            is_hit = 1'b0;
            #1;

            check_outputs(9'h1AA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: is_hit is 1 but hit_times is only 3", test_num);
            rgb_bullet = 9'h0F0;
            default_color = 9'h100;
            hit_times = 5'd3;
            is_hit = 1'b1;
            #1;

            check_outputs(9'h0F0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: CONDITION MET - hit_times is 4 and is_hit is 1", test_num);
            rgb_bullet = 9'h1FF;
            default_color = 9'h0A5;
            hit_times = 5'd4;
            is_hit = 1'b1;
            #1;

            check_outputs(9'h0A5);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: hit_times is 5 (past 4) and is_hit is 1", test_num);
            rgb_bullet = 9'h077;
            default_color = 9'h111;
            hit_times = 5'd5;
            is_hit = 1'b1;
            #1;

            check_outputs(9'h077);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random inputs check", test_num);
            rgb_bullet = 9'h123;
            default_color = 9'h001;
            hit_times = 5'd10;
            is_hit = 1'b0;
            #1;

            check_outputs(9'h123);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Edge case hit_times=4, is_hit=1 with different colors", test_num);
            rgb_bullet = 9'h000;
            default_color = 9'h1FF;
            hit_times = 5'd4;
            is_hit = 1'b1;
            #1;

            check_outputs(9'h1FF);
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
        input [8:0] expected_rgb_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_rgb_out === (expected_rgb_out ^ rgb_out ^ expected_rgb_out)) begin
                $display("PASS");
                $display("  Outputs: rgb_out=%h",
                         rgb_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rgb_out=%h",
                         expected_rgb_out);
                $display("  Got:      rgb_out=%h",
                         rgb_out);
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
