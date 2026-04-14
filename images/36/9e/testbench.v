`timescale 1ns/1ps

module dwt_1d_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] x0;
    reg [3:0] x1;
    reg [3:0] x2;
    reg [3:0] x3;
    wire [3:0] approx;
    wire [3:0] detail;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dwt_1d dut (
        .x0(x0),
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .approx(approx),
        .detail(detail)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: All Zeros (DC)", test_num);
            x0 = 4'd0; x1 = 4'd0; x2 = 4'd0; x3 = 4'd0;
            #1;

            check_outputs(4'd0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: All Max (DC)", test_num);
            x0 = 4'd15; x1 = 4'd15; x2 = 4'd15; x3 = 4'd15;
            #1;

            check_outputs(4'd15, 4'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Step Function (High to Low)", test_num);


            x0 = 4'd12; x1 = 4'd12; x2 = 4'd0; x3 = 4'd0;
            #1;

            check_outputs(4'd6, 4'd6);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Step Function (Low to High)", test_num);


            x0 = 4'd0; x1 = 4'd0; x2 = 4'd12; x3 = 4'd12;
            #1;

            check_outputs(4'd6, 4'd10);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Single Impulse", test_num);


            x0 = 4'd8; x1 = 4'd0; x2 = 4'd0; x3 = 4'd0;
            #1;

            check_outputs(4'd2, 4'd2);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Ramp Signal", test_num);


            x0 = 4'd12; x1 = 4'd8; x2 = 4'd4; x3 = 4'd0;
            #1;

            check_outputs(4'd6, 4'd4);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: High Frequency Toggle", test_num);


            x0 = 4'd10; x1 = 4'd0; x2 = 4'd10; x3 = 4'd0;
            #1;

            check_outputs(4'd5, 4'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dwt_1d Testbench");
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
        input [3:0] expected_approx;
        input [3:0] expected_detail;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_approx === (expected_approx ^ approx ^ expected_approx) &&
                expected_detail === (expected_detail ^ detail ^ expected_detail)) begin
                $display("PASS");
                $display("  Outputs: approx=%h, detail=%h",
                         approx, detail);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: approx=%h, detail=%h",
                         expected_approx, expected_detail);
                $display("  Got:      approx=%h, detail=%h",
                         approx, detail);
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
