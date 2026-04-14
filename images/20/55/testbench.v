`timescale 1ns/1ps

module kmeans_distance_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] x1;
    reg [4:0] x2;
    reg [4:0] x3;
    reg [4:0] x_ref;
    reg [4:0] y1;
    reg [4:0] y2;
    reg [4:0] y3;
    reg [4:0] y_ref;
    wire [7:0] distance1;
    wire [7:0] distance2;
    wire [7:0] distance3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kmeans_distance dut (
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .x_ref(x_ref),
        .y1(y1),
        .y2(y2),
        .y3(y3),
        .y_ref(y_ref),
        .distance1(distance1),
        .distance2(distance2),
        .distance3(distance3)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All points and reference at origin", test_num);
            x1 = 5'd0; y1 = 5'd0;
            x2 = 5'd0; y2 = 5'd0;
            x3 = 5'd0; y3 = 5'd0;
            x_ref = 5'd0; y_ref = 5'd0;
            #1;

            check_outputs(8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Simple integer coordinates from origin", test_num);



            x1 = 5'd3; y1 = 5'd4;
            x2 = 5'd6; y2 = 5'd8;
            x3 = 5'd1; y3 = 5'd1;
            x_ref = 5'd0; y_ref = 5'd0;
            #1;

            check_outputs(8'h19, 8'h64, 8'h02);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Reference point at (15,15)", test_num);



            x1 = 5'd10; y1 = 5'd10;
            x2 = 5'd20; y2 = 5'd20;
            x3 = 5'd15; y3 = 5'd15;
            x_ref = 5'd15; y_ref = 5'd15;
            #1;

            check_outputs(8'h32, 8'h32, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Large values within 8-bit limit", test_num);



            x1 = 5'd15; y1 = 5'd0;
            x2 = 5'd0;  y2 = 5'd15;
            x3 = 5'd11; y3 = 5'd11;
            x_ref = 5'd0; y_ref = 5'd0;
            #1;

            check_outputs(8'hE1, 8'hE1, 8'hF2);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Testing bit truncation (Squared distance > 255)", test_num);



            x1 = 5'd16; y1 = 5'd0;
            x2 = 5'd31; y2 = 5'd0;
            x3 = 5'd31; y3 = 5'd31;
            x_ref = 5'd0; y_ref = 5'd0;
            #1;

            check_outputs(8'h00, 8'hC1, 8'h82);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Negative coordinate differences", test_num);



            x1 = 5'd5;  y1 = 5'd5;
            x2 = 5'd0;  y2 = 5'd0;
            x3 = 5'd2;  y3 = 5'd2;
            x_ref = 5'd10; y_ref = 5'd10;
            #1;

            check_outputs(8'h32, 8'hC8, 8'h80);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("kmeans_distance Testbench");
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
        input [7:0] expected_distance1;
        input [7:0] expected_distance2;
        input [7:0] expected_distance3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_distance1 === (expected_distance1 ^ distance1 ^ expected_distance1) &&
                expected_distance2 === (expected_distance2 ^ distance2 ^ expected_distance2) &&
                expected_distance3 === (expected_distance3 ^ distance3 ^ expected_distance3)) begin
                $display("PASS");
                $display("  Outputs: distance1=%h, distance2=%h, distance3=%h",
                         distance1, distance2, distance3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: distance1=%h, distance2=%h, distance3=%h",
                         expected_distance1, expected_distance2, expected_distance3);
                $display("  Got:      distance1=%h, distance2=%h, distance3=%h",
                         distance1, distance2, distance3);
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
