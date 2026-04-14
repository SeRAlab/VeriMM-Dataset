`timescale 1ns/1ps

module kmeans_clustering_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] centroid1_x;
    reg [7:0] centroid1_y;
    reg [7:0] centroid2_x;
    reg [7:0] centroid2_y;
    reg [7:0] point_x;
    reg [7:0] point_y;
    wire [1:0] cluster;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kmeans_clustering dut (
        .centroid1_x(centroid1_x),
        .centroid1_y(centroid1_y),
        .centroid2_x(centroid2_x),
        .centroid2_y(centroid2_y),
        .point_x(point_x),
        .point_y(point_y),
        .cluster(cluster)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Point close to Centroid 1", test_num);
            centroid1_x = 8'd10;  centroid1_y = 8'd10;
            centroid2_x = 8'd100; centroid2_y = 8'd100;
            point_x     = 8'd20;  point_y     = 8'd20;


            #1;



            check_outputs(2'b01);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Point close to Centroid 2", test_num);
            centroid1_x = 8'd10;  centroid1_y = 8'd10;
            centroid2_x = 8'd100; centroid2_y = 8'd100;
            point_x     = 8'd90;  point_y     = 8'd95;


            #1;



            check_outputs(2'b10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Point exactly on Centroid 1", test_num);
            centroid1_x = 8'd50;  centroid1_y = 8'd50;
            centroid2_x = 8'd200; centroid2_y = 8'd200;
            point_x     = 8'd50;  point_y     = 8'd50;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Point exactly on Centroid 2", test_num);
            centroid1_x = 8'd50;  centroid1_y = 8'd50;
            centroid2_x = 8'd200; centroid2_y = 8'd200;
            point_x     = 8'd200; point_y     = 8'd200;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Horizontal distance check (Closer to C1)", test_num);
            centroid1_x = 8'd10;  centroid1_y = 8'd50;
            centroid2_x = 8'd20;  centroid2_y = 8'd50;
            point_x     = 8'd12;  point_y     = 8'd50;

            #1;


            check_outputs(2'b01);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Vertical distance check (Closer to C2)", test_num);
            centroid1_x = 8'd100; centroid1_y = 8'd10;
            centroid2_x = 8'd100; centroid2_y = 8'd30;
            point_x     = 8'd100; point_y     = 8'd25;

            #1;


            check_outputs(2'b10);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Large coordinate boundaries", test_num);
            centroid1_x = 8'd0;   centroid1_y = 8'd0;
            centroid2_x = 8'd255; centroid2_y = 8'd255;
            point_x     = 8'd250; point_y     = 8'd250;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Subtle difference check", test_num);
            centroid1_x = 8'd100; centroid1_y = 8'd100;
            centroid2_x = 8'd110; centroid2_y = 8'd110;
            point_x     = 8'd105; point_y     = 8'd106;


            #1;



            check_outputs(2'b10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("kmeans_clustering Testbench");
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
        input [1:0] expected_cluster;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cluster === (expected_cluster ^ cluster ^ expected_cluster)) begin
                $display("PASS");
                $display("  Outputs: cluster=%h",
                         cluster);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cluster=%h",
                         expected_cluster);
                $display("  Got:      cluster=%h",
                         cluster);
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
