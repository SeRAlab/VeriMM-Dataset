`timescale 1ns/1ps

module dijkstra_min_distance_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] dist1;
    reg [7:0] dist2;
    reg [7:0] dist3;
    wire [7:0] min_dist;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dijkstra_min_distance dut (
        .dist1(dist1),
        .dist2(dist2),
        .dist3(dist3),
        .min_dist(min_dist)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: dist1 is minimum", test_num);
            dist1 = 8'd10;
            dist2 = 8'd20;
            dist3 = 8'd30;
            #1;

            check_outputs(8'd10);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: dist2 is minimum", test_num);
            dist1 = 8'd50;
            dist2 = 8'd5;
            dist3 = 8'd100;
            #1;

            check_outputs(8'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: dist3 is minimum", test_num);
            dist1 = 8'd200;
            dist2 = 8'd150;
            dist3 = 8'd10;
            #1;

            check_outputs(8'd10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All inputs equal", test_num);
            dist1 = 8'd42;
            dist2 = 8'd42;
            dist3 = 8'd42;
            #1;

            check_outputs(8'd42);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Two inputs equal and minimum", test_num);
            dist1 = 8'd15;
            dist2 = 8'd15;
            dist3 = 8'd80;
            #1;

            check_outputs(8'd15);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Two inputs equal and maximum", test_num);
            dist1 = 8'd90;
            dist2 = 8'd30;
            dist3 = 8'd90;
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Edge values (0 and 255)", test_num);
            dist1 = 8'd0;
            dist2 = 8'd255;
            dist3 = 8'd128;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All inputs at maximum value", test_num);
            dist1 = 8'hFF;
            dist2 = 8'hFF;
            dist3 = 8'hFF;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Gradient values (decreasing order)", test_num);
            dist1 = 8'd100;
            dist2 = 8'd99;
            dist3 = 8'd98;
            #1;

            check_outputs(8'd98);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Gradient values (increasing order)", test_num);
            dist1 = 8'd50;
            dist2 = 8'd51;
            dist3 = 8'd52;
            #1;

            check_outputs(8'd50);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dijkstra_min_distance Testbench");
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
        input [7:0] expected_min_dist;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_min_dist === (expected_min_dist ^ min_dist ^ expected_min_dist)) begin
                $display("PASS");
                $display("  Outputs: min_dist=%h",
                         min_dist);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: min_dist=%h",
                         expected_min_dist);
                $display("  Got:      min_dist=%h",
                         min_dist);
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
