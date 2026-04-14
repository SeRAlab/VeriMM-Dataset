`timescale 1ns/1ps

module kmeans_clustering_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] x1;
    reg [7:0] x2;
    reg [7:0] y1;
    reg [7:0] y2;
    wire closest_centroid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kmeans_clustering dut (
        .x1(x1),
        .x2(x2),
        .y1(y1),
        .y2(y2),
        .closest_centroid(closest_centroid)
    );
    task testcase001;

        begin
            test_num = 1;
            x1 = 8'd0; y1 = 8'd0;
            x2 = 8'd0; y2 = 8'd0;
            $display("Testcase %03d: Input (0,0). Expected Centroid C0 (0)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            x1 = 8'd1; y1 = 8'd1;
            x2 = 8'd1; y2 = 8'd1;
            $display("Testcase %03d: Input (1,1). Expected Centroid C1 (1)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            x1 = 8'd10; y1 = 8'd10;
            x2 = 8'd10; y2 = 8'd10;
            $display("Testcase %03d: Input (10,10). Expected Centroid C1 (1)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            x1 = 8'd0; y1 = 8'd1;
            x2 = 8'd0; y2 = 8'd1;
            $display("Testcase %03d: Input (0,1) [Tie Case]. Expected Centroid C0 (0)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            x1 = 8'd255; y1 = 8'd255;
            x2 = 8'd255; y2 = 8'd255;
            $display("Testcase %03d: Input (255,255). Expected Centroid C1 (1)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            x1 = 8'd1; y1 = 8'd2;
            x2 = 8'd1; y2 = 8'd2;
            $display("Testcase %03d: Input (1,2). Expected Centroid C1 (1)", test_num);
            #1;

            check_outputs(1'b1);
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
        input expected_closest_centroid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_closest_centroid === (expected_closest_centroid ^ closest_centroid ^ expected_closest_centroid)) begin
                $display("PASS");
                $display("  Outputs: closest_centroid=%b",
                         closest_centroid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: closest_centroid=%b",
                         expected_closest_centroid);
                $display("  Got:      closest_centroid=%b",
                         closest_centroid);
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
