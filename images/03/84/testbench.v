`timescale 1ns/1ps

module hough_transform_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] angle;
    reg [3:0] distance;
    wire line_detected;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hough_transform dut (
        .angle(angle),
        .distance(distance),
        .line_detected(line_detected)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: Angle=0, Distance=0", test_num);
        angle = 4'd0;
        distance = 4'd0;


        #1;



        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: Angle=15, Distance=15", test_num);
        angle = 4'd15;
        distance = 4'd15;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: Angle=5, Distance=10", test_num);
        angle = 4'd5;
        distance = 4'd10;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: Angle=12, Distance=4", test_num);
        angle = 4'd12;
        distance = 4'd4;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: Angle=8, Distance=8", test_num);
        angle = 4'd8;
        distance = 4'd8;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: Angle=0, Distance=12", test_num);
        angle = 4'd0;
        distance = 4'd12;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: Angle=4, Distance=6", test_num);
        angle = 4'd4;
        distance = 4'd6;

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
        $display("hough_transform Testbench");
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
        input expected_line_detected;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_line_detected === (expected_line_detected ^ line_detected ^ expected_line_detected)) begin
                $display("PASS");
                $display("  Outputs: line_detected=%b",
                         line_detected);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: line_detected=%b",
                         expected_line_detected);
                $display("  Got:      line_detected=%b",
                         line_detected);
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
