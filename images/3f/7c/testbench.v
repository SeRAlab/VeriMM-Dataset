`timescale 1ns/1ps

module ecc_point_addition_tb;

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
            $display("Test Case %0d: Basic Point Addition (P1 != P2)", test_num);

            x1 = 8'h05;
            y1 = 8'h01;
            x2 = 8'h0A;
            y2 = 8'h0C;


            #1;



            check_outputs(8'h0F, 8'h0D);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Point Doubling (P1 == P2)", test_num);

            x1 = 8'h03;
            y1 = 8'h04;
            x2 = 8'h03;
            y2 = 8'h04;

            #1;


            check_outputs(8'h12, 8'h07);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary Values (Large Coordinates)", test_num);
            x1 = 8'hFF;
            y1 = 8'hAA;
            x2 = 8'h01;
            y2 = 8'h02;

            #1;


            check_outputs(8'h4B, 8'hA2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Inverse Point Addition (Result Infinity/Zero)", test_num);

            x1 = 8'h20;
            y1 = 8'h15;
            x2 = 8'h20;
            y2 = 8'hE5;

            #1;


            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition with Identity Point", test_num);

            x1 = 8'h00;
            y1 = 8'h00;
            x2 = 8'h14;
            y2 = 8'h2B;

            #1;


            check_outputs(8'h14, 8'h2B);
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
