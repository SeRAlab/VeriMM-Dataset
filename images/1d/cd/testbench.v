`timescale 1ns/1ps

module kmeans_clustering_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] center0_x;
    reg [7:0] center0_y;
    reg [7:0] center1_x;
    reg [7:0] center1_y;
    reg [7:0] point_x;
    reg [7:0] point_y;
    wire nearest_center;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kmeans_clustering dut (
        .center0_x(center0_x),
        .center0_y(center0_y),
        .center1_x(center1_x),
        .center1_y(center1_y),
        .point_x(point_x),
        .point_y(point_y),
        .nearest_center(nearest_center)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        center0_x = 8'd10;  center0_y = 8'd10;
        center1_x = 8'd100; center1_y = 8'd100;
        point_x   = 8'd10;  point_y   = 8'd10;
        $display("Test %0d: Point exactly at Center 0", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        center0_x = 8'd10;  center0_y = 8'd10;
        center1_x = 8'd100; center1_y = 8'd100;
        point_x   = 8'd100; point_y   = 8'd100;
        $display("Test %0d: Point exactly at Center 1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        center0_x = 8'd0;   center0_y = 8'd0;
        center1_x = 8'd10;  center1_y = 8'd10;
        point_x   = 8'd2;   point_y   = 8'd2;


        $display("Test %0d: Point closer to Center 0", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        center0_x = 8'd0;   center0_y = 8'd0;
        center1_x = 8'd10;  center1_y = 8'd10;
        point_x   = 8'd8;   point_y   = 8'd8;


        $display("Test %0d: Point closer to Center 1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        center0_x = 8'd0;   center0_y = 8'd0;
        center1_x = 8'd10;  center1_y = 8'd0;
        point_x   = 8'd5;   point_y   = 8'd0;


        $display("Test %0d: Equidistant point (should favor index 0)", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        center0_x = 8'd50;  center0_y = 8'd20;
        center1_x = 8'd50;  center1_y = 8'd80;
        point_x   = 8'd50;  point_y   = 8'd70;


        $display("Test %0d: Vertical proximity to Center 1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        center0_x = 8'd10;  center0_y = 8'd100;
        center1_x = 8'd90;  center1_y = 8'd100;
        point_x   = 8'd20;  point_y   = 8'd100;


        $display("Test %0d: Horizontal proximity to Center 0", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        center0_x = 8'd255; center0_y = 8'd255;
        center1_x = 8'd0;   center1_y = 8'd0;
        point_x   = 8'd128; point_y   = 8'd128;


        $display("Test %0d: Diagonal mid-point test (closer to C0)", test_num);
        #1;

        check_outputs(1'b0);
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
        input expected_nearest_center;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_nearest_center === (expected_nearest_center ^ nearest_center ^ expected_nearest_center)) begin
                $display("PASS");
                $display("  Outputs: nearest_center=%b",
                         nearest_center);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: nearest_center=%b",
                         expected_nearest_center);
                $display("  Got:      nearest_center=%b",
                         nearest_center);
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
