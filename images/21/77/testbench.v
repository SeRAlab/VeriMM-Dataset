`timescale 1ns/1ps

module ecc_point_addition_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] x1;
    reg [15:0] x2;
    reg [15:0] y1;
    reg [15:0] y2;
    wire [15:0] x3;
    wire [15:0] y3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ecc_point_addition dut (
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
            $display("Test Case %0d: Addition of distinct points (5,1) + (6,3)", test_num);
            x1 = 16'h0005; y1 = 16'h0001;
            x2 = 16'h0006; y2 = 16'h0003;
            #1;

            check_outputs(16'h000A, 16'h0006);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Point Doubling 2*(5,1)", test_num);
            x1 = 16'h0005; y1 = 16'h0001;
            x2 = 16'h0005; y2 = 16'h0001;
            #1;

            check_outputs(16'h0006, 16'h0003);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Inverse points (5,1) + (5,16)", test_num);
            x1 = 16'h0005; y1 = 16'h0001;
            x2 = 16'h0005; y2 = 16'h0010;
            #1;

            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Identity Addition (0,0) + (10,6)", test_num);
            x1 = 16'h0000; y1 = 16'h0000;
            x2 = 16'h000A; y2 = 16'h0006;
            #1;

            check_outputs(16'h000A, 16'h0006);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Point Doubling 2*(10,6)", test_num);
            x1 = 16'h000A; y1 = 16'h0006;
            x2 = 16'h000A; y2 = 16'h0006;
            #1;

            check_outputs(16'h0010, 16'h000D);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition of (6,3) + (10,6)", test_num);
            x1 = 16'h0006; y1 = 16'h0003;
            x2 = 16'h000A; y2 = 16'h0006;
            #1;

            check_outputs(16'h0009, 16'h0010);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ecc_point_addition Testbench");
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
        input [15:0] expected_x3;
        input [15:0] expected_y3;
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
