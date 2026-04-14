`timescale 1ns/1ps

module kmeans_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] centroid_x0;
    reg [7:0] centroid_x1;
    reg [7:0] centroid_y0;
    reg [7:0] centroid_y1;
    reg clk;
    reg [7:0] data_point_x0;
    reg [7:0] data_point_x1;
    reg [7:0] data_point_y0;
    reg [7:0] data_point_y1;
    reg reset;
    wire [1:0] cluster_label0;
    wire [1:0] cluster_label1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kmeans dut (
        .centroid_x0(centroid_x0),
        .centroid_x1(centroid_x1),
        .centroid_y0(centroid_y0),
        .centroid_y1(centroid_y1),
        .clk(clk),
        .data_point_x0(data_point_x0),
        .data_point_x1(data_point_x1),
        .data_point_y0(data_point_y0),
        .data_point_y1(data_point_y1),
        .reset(reset),
        .cluster_label0(cluster_label0),
        .cluster_label1(cluster_label1)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            centroid_x0 = 0;
            centroid_x1 = 0;
            centroid_y0 = 0;
            centroid_y1 = 0;
            data_point_x0 = 0;
            data_point_x1 = 0;
            data_point_y0 = 0;
            data_point_y1 = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Standard Separation", test_num);
            reset_dut();

            centroid_x0 = 8'd10;  centroid_y0 = 8'd10;
            centroid_x1 = 8'd100; centroid_y1 = 8'd100;

            data_point_x0 = 8'd15;  data_point_y0 = 8'd15;
            data_point_x1 = 8'd90;  data_point_y1 = 8'd95;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(2'd0, 2'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Swapped Proximity", test_num);
            reset_dut();

            centroid_x0 = 8'd20;  centroid_y0 = 8'd20;
            centroid_x1 = 8'd200; centroid_y1 = 8'd200;

            data_point_x0 = 8'd210; data_point_y0 = 8'd210;
            data_point_x1 = 8'd10;  data_point_y1 = 8'd10;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(2'd1, 2'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Proximity", test_num);
            reset_dut();

            centroid_x0 = 8'd50;  centroid_y0 = 8'd50;
            centroid_x1 = 8'd150; centroid_y1 = 8'd50;

            data_point_x0 = 8'd95;  data_point_y0 = 8'd50;
            data_point_x1 = 8'd105; data_point_y1 = 8'd50;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(2'd0, 2'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Vertical Alignment", test_num);
            reset_dut();

            centroid_x0 = 8'd100; centroid_y0 = 8'd20;
            centroid_x1 = 8'd100; centroid_y1 = 8'd200;

            data_point_x0 = 8'd10;  data_point_y0 = 8'd30;
            data_point_x1 = 8'd250; data_point_y1 = 8'd190;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(2'd0, 2'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Cluster Assignment", test_num);
            reset_dut();

            centroid_x0 = 8'd10;  centroid_y0 = 8'd10;
            centroid_x1 = 8'd250; centroid_y1 = 8'd250;

            data_point_x0 = 8'd200; data_point_y0 = 8'd200;
            data_point_x1 = 8'd240; data_point_y1 = 8'd240;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(2'd1, 2'd1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("kmeans Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [1:0] expected_cluster_label0;
        input [1:0] expected_cluster_label1;
        begin
            if (expected_cluster_label0 === (expected_cluster_label0 ^ cluster_label0 ^ expected_cluster_label0) &&
                expected_cluster_label1 === (expected_cluster_label1 ^ cluster_label1 ^ expected_cluster_label1)) begin
                $display("PASS");
                $display("  Outputs: cluster_label0=%h, cluster_label1=%h",
                         cluster_label0, cluster_label1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cluster_label0=%h, cluster_label1=%h",
                         expected_cluster_label0, expected_cluster_label1);
                $display("  Got:      cluster_label0=%h, cluster_label1=%h",
                         cluster_label0, cluster_label1);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,centroid_x0, centroid_x1, centroid_y0, centroid_y1, clk, data_point_x0, data_point_x1, data_point_y0, data_point_y1, reset, cluster_label0, cluster_label1);
    end

endmodule
