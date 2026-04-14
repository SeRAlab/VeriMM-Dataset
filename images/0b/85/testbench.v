`timescale 1ns/1ps

module k_means_cluster_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] point1;
    reg [4:0] point2;
    reg [4:0] point3;
    wire [4:0] cluster_center;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    k_means_cluster dut (
        .point1(point1),
        .point2(point2),
        .point3(point3),
        .cluster_center(cluster_center)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All inputs zero", test_num);
            point1 = 5'd0;
            point2 = 5'd0;
            point3 = 5'd0;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All inputs max (31)", test_num);
            point1 = 5'd31;
            point2 = 5'd31;
            point3 = 5'd31;
            #1;

            check_outputs(5'd31);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Identical values (15)", test_num);
            point1 = 5'd15;
            point2 = 5'd15;
            point3 = 5'd15;
            #1;

            check_outputs(5'd15);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Exact average (1, 2, 3)", test_num);
            point1 = 5'd1;
            point2 = 5'd2;
            point3 = 5'd3;
            #1;

            check_outputs(5'd2);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Exact average (10, 20, 30)", test_num);
            point1 = 5'd10;
            point2 = 5'd20;
            point3 = 5'd30;
            #1;

            check_outputs(5'd20);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Truncation check (1, 1, 2)", test_num);
            point1 = 5'd1;
            point2 = 5'd1;
            point3 = 5'd2;
            #1;

            check_outputs(5'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Truncation check (2, 2, 1)", test_num);
            point1 = 5'd2;
            point2 = 5'd2;
            point3 = 5'd1;
            #1;

            check_outputs(5'd1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: High values truncation (31, 31, 30)", test_num);
            point1 = 5'd31;
            point2 = 5'd31;
            point3 = 5'd30;
            #1;

            check_outputs(5'd30);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero and Max mix", test_num);
            point1 = 5'd0;
            point2 = 5'd31;
            point3 = 5'd0;
            #1;

            check_outputs(5'd10);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sequential values", test_num);
            point1 = 5'd16;
            point2 = 5'd17;
            point3 = 5'd18;
            #1;

            check_outputs(5'd17);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("k_means_cluster Testbench");
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
        input [4:0] expected_cluster_center;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cluster_center === (expected_cluster_center ^ cluster_center ^ expected_cluster_center)) begin
                $display("PASS");
                $display("  Outputs: cluster_center=%h",
                         cluster_center);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cluster_center=%h",
                         expected_cluster_center);
                $display("  Got:      cluster_center=%h",
                         cluster_center);
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
