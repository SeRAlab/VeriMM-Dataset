`timescale 1ns/1ps

module non_maximum_suppression_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] center;
    reg [7:0] neighbor1;
    reg [7:0] neighbor2;
    wire edge_detected;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    non_maximum_suppression dut (
        .center(center),
        .neighbor1(neighbor1),
        .neighbor2(neighbor2),
        .edge_detected(edge_detected)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Center is clear maximum", test_num);
            center = 8'd100;
            neighbor1 = 8'd50;
            neighbor2 = 8'd50;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Neighbor 1 is larger", test_num);
            center = 8'd100;
            neighbor1 = 8'd150;
            neighbor2 = 8'd50;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Neighbor 2 is larger", test_num);
            center = 8'd100;
            neighbor1 = 8'd50;
            neighbor2 = 8'd150;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Both neighbors are larger", test_num);
            center = 8'd100;
            neighbor1 = 8'd120;
            neighbor2 = 8'd120;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Center equals Neighbor 1 (Plateau Suppression)", test_num);
            center = 8'd100;
            neighbor1 = 8'd100;
            neighbor2 = 8'd50;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All pixels equal", test_num);
            center = 8'd100;
            neighbor1 = 8'd100;
            neighbor2 = 8'd100;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Center is absolute maximum (255)", test_num);
            center = 8'd255;
            neighbor1 = 8'd254;
            neighbor2 = 8'd254;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All zero values", test_num);
            center = 8'd0;
            neighbor1 = 8'd0;
            neighbor2 = 8'd0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Center is 1 unit larger than neighbors", test_num);
            center = 8'd128;
            neighbor1 = 8'd127;
            neighbor2 = 8'd127;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Center is zero, neighbors higher", test_num);
            center = 8'd0;
            neighbor1 = 8'd10;
            neighbor2 = 8'd10;
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
        $display("non_maximum_suppression Testbench");
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
        input expected_edge_detected;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_edge_detected === (expected_edge_detected ^ edge_detected ^ expected_edge_detected)) begin
                $display("PASS");
                $display("  Outputs: edge_detected=%b",
                         edge_detected);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: edge_detected=%b",
                         expected_edge_detected);
                $display("  Got:      edge_detected=%b",
                         edge_detected);
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
