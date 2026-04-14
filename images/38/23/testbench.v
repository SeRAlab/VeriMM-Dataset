`timescale 1ns/1ps

module ECC_Point_Addition_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] x1;
    reg [7:0] x2;
    reg [7:0] y1;
    reg [7:0] y2;
    wire [7:0] x3;
    wire [7:0] y3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ECC_Point_Addition dut (
        .x1(x1),
        .x2(x2),
        .y1(y1),
        .y2(y2),
        .x3(x3),
        .y3(y3)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition of distinct points P1(0,1) + P2(1,7)", test_num);
            x1 = 8'd0; y1 = 8'd1;
            x2 = 8'd1; y2 = 8'd7;
            #1;

            check_outputs(8'd12, 8'd19);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Point Doubling P1(1,7) + P1(1,7)", test_num);
            x1 = 8'd1; y1 = 8'd7;
            x2 = 8'd1; y2 = 8'd7;
            #1;

            check_outputs(8'd7, 8'd11);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Identity Addition (Point at Infinity)", test_num);
            x1 = 8'd0; y1 = 8'd0;
            x2 = 8'd3; y2 = 8'd10;
            #1;

            check_outputs(8'd3, 8'd10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Inverse Point Addition (P + -P)", test_num);
            x1 = 8'd1; y1 = 8'd7;
            x2 = 8'd1; y2 = 8'd16;
            #1;

            check_outputs(8'd0, 8'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Commutative Property (P2 + P1)", test_num);
            x1 = 8'd1; y1 = 8'd7;
            x2 = 8'd0; y2 = 8'd1;
            #1;

            check_outputs(8'd12, 8'd19);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ECC_Point_Addition Testbench");
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
        input [7:0] expected_x3;
        input [7:0] expected_y3;
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
