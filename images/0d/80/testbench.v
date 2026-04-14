`timescale 1ns/1ps

module knn_classifier_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] point1_x;
    reg [7:0] point1_y;
    reg [7:0] point2_x;
    reg [7:0] point2_y;
    reg [7:0] point_x;
    reg [7:0] point_y;
    wire classification;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    knn_classifier dut (
        .point1_x(point1_x),
        .point1_y(point1_y),
        .point2_x(point2_x),
        .point2_y(point2_y),
        .point_x(point_x),
        .point_y(point_y),
        .classification(classification)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Target identical to Point 1", test_num);
        point1_x = 8'd10; point1_y = 8'd10;
        point2_x = 8'd100; point2_y = 8'd100;
        point_x  = 8'd10;  point_y  = 8'd10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Target identical to Point 2", test_num);
        point1_x = 8'd10;  point1_y = 8'd10;
        point2_x = 8'd100; point2_y = 8'd100;
        point_x  = 8'd100; point_y  = 8'd100;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Target closer to Point 1 (Diagonal)", test_num);
        point1_x = 8'd20;  point1_y = 8'd20;
        point2_x = 8'd80;  point2_y = 8'd80;
        point_x  = 8'd30;  point_y  = 8'd30;


        #1;



        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Target closer to Point 2 (Diagonal)", test_num);
        point1_x = 8'd20;  point1_y = 8'd20;
        point2_x = 8'd80;  point2_y = 8'd80;
        point_x  = 8'd70;  point_y  = 8'd70;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Closer to P1 on horizontal axis", test_num);
        point1_x = 8'd50;  point1_y = 8'd100;
        point2_x = 8'd150; point2_y = 8'd100;
        point_x  = 8'd60;  point_y  = 8'd100;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Closer to P2 on vertical axis", test_num);
        point1_x = 8'd100; point1_y = 8'd50;
        point2_x = 8'd100; point2_y = 8'd150;
        point_x  = 8'd100; point_y  = 8'd140;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Handling maximum coordinate values", test_num);
        point1_x = 8'd255; point1_y = 8'd255;
        point2_x = 8'd0;   point2_y = 8'd0;
        point_x  = 8'd200; point_y  = 8'd200;


        #1;



        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Target near midpoint, slightly closer to P2", test_num);
        point1_x = 8'd0;   point1_y = 8'd0;
        point2_x = 8'd10;  point2_y = 8'd10;
        point_x  = 8'd6;   point_y  = 8'd6;


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
        $display("knn_classifier Testbench");
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
        input expected_classification;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_classification === (expected_classification ^ classification ^ expected_classification)) begin
                $display("PASS");
                $display("  Outputs: classification=%b",
                         classification);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: classification=%b",
                         expected_classification);
                $display("  Got:      classification=%b",
                         classification);
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
