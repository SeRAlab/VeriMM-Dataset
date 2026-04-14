`timescale 1ns/1ps

module ECC_Point_Addition_tb;

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
            $display("Test %0d: Basic Point Addition (P + Q where P != Q)", test_num);

            x1 = 4'd1; y1 = 4'd4;
            x2 = 4'd2; y2 = 4'd7;

            #1;


            check_outputs(4'd5, 4'd2);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Point Doubling (P + P)", test_num);

            x1 = 4'd3; y1 = 4'd6;
            x2 = 4'd3; y2 = 4'd6;

            #1;


            check_outputs(4'd8, 4'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition with Identity Element (P + O)", test_num);

            x1 = 4'd5; y1 = 4'd9;
            x2 = 4'd0; y2 = 4'd0;
            #1;

            check_outputs(4'd5, 4'd9);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition of Inverse Points (P + (-P))", test_num);

            x1 = 4'd4; y1 = 4'd3;
            x2 = 4'd4; y2 = 4'd10;
            #1;

            check_outputs(4'd0, 4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max Value Boundary Test", test_num);
            x1 = 4'hF; y1 = 4'hF;
            x2 = 4'h1; y2 = 4'h2;

            #1;


            check_outputs(4'hC, 4'h4);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Symmetrical Small Values", test_num);
            x1 = 4'd2; y1 = 4'd1;
            x2 = 4'd1; y2 = 4'd2;

            #1;


            check_outputs(4'd3, 4'd3);
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
