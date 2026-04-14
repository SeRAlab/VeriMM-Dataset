`timescale 1ns/1ps

module point_addition_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] x1;
    reg [3:0] x2;
    reg [3:0] y1;
    reg [3:0] y2;
    wire [3:0] x3;
    wire [3:0] y3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    point_addition dut (
        .x1(x1),
        .x2(x2),
        .y1(y1),
        .y2(y2),
        .x3(x3),
        .y3(y3)
    );
    task testcase001;

    begin
        test_num = 1;
        x1 = 4'd2; y1 = 4'd2;
        x2 = 4'd3; y2 = 4'd1;
        #10;
        $display("Test %0d: Addition of distinct points (2,2) + (3,1)", test_num);
        #1;

        check_outputs(4'd7, 4'd3);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        x1 = 4'd2; y1 = 4'd9;
        x2 = 4'd5; y2 = 4'd0;
        #10;
        $display("Test %0d: Addition involving y=0: (2,9) + (5,0)", test_num);
        #1;

        check_outputs(4'd2, 4'd2);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        x1 = 4'd2; y1 = 4'd2;
        x2 = 4'd2; y2 = 4'd2;
        #10;
        $display("Test %0d: Point Doubling (2,2) + (2,2)", test_num);
        #1;

        check_outputs(4'd5, 4'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        x1 = 4'd3; y1 = 4'd10;
        x2 = 4'd4; y2 = 4'd4;
        #10;
        $display("Test %0d: Addition of (3,10) + (4,4)", test_num);
        #1;

        check_outputs(4'd7, 4'd3);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        x1 = 4'd4; y1 = 4'd4;
        x2 = 4'd4; y2 = 4'd4;
        #10;
        $display("Test %0d: Point Doubling (4,4) + (4,4)", test_num);
        #1;

        check_outputs(4'd6, 4'd6);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        x1 = 4'd2; y1 = 4'd2;
        x2 = 4'd2; y2 = 4'd9;
        #10;
        $display("Test %0d: Additive Inverses (2,2) + (2,9)", test_num);
        #1;

        check_outputs(4'd0, 4'd0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("point_addition Testbench");
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
        input [3:0] expected_x3;
        input [3:0] expected_y3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_x3 === (expected_x3 ^ x3 ^ expected_x3) &&
                expected_y3 === (expected_y3 ^ y3 ^ expected_y3)) begin
                $display("PASS");
                $display("  Outputs: x3=%h, y3=%h",
                         x3, y3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x3=%h, y3=%h",
                         expected_x3, expected_y3);
                $display("  Got:      x3=%h, y3=%h",
                         x3, y3);
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
