`timescale 1ns/1ps

module dwt_1d_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] x0;
    reg [7:0] x1;
    reg [7:0] x2;
    reg [7:0] x3;
    wire [7:0] high_pass0;
    wire [7:0] high_pass1;
    wire [7:0] low_pass0;
    wire [7:0] low_pass1;

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
        .high_pass0(high_pass0),
        .high_pass1(high_pass1),
        .low_pass0(low_pass0),
        .low_pass1(low_pass1)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Zeros", test_num);
            x0 = 8'h00; x1 = 8'h00; x2 = 8'h00; x3 = 8'h00;
            #1;

            check_outputs(8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Uniform Positive Values", test_num);
            x0 = 8'd50; x1 = 8'd50; x2 = 8'd100; x3 = 8'd100;

            #1;


            check_outputs(8'd0, 8'd0, 8'd50, 8'd100);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: High Frequency Signal", test_num);
            x0 = 8'd20; x1 = -8'd20; x2 = 8'd40; x3 = -8'd40;





            #1;






            check_outputs(8'd20, 8'd40, 8'd0, 8'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Mixed Values", test_num);
            x0 = 8'd100; x1 = 8'd20; x2 = -8'd60; x3 = -8'd100;





            #1;






            check_outputs(8'h28, 8'h14, 8'h3C, 8'hB0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Boundary Values", test_num);
            x0 = 8'd120; x1 = -8'd120; x2 = -8'd100; x3 = 8'd100;



            #1;




            check_outputs(8'h78, 8'h9C, 8'h00, 8'h00);
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
        input [7:0] expected_high_pass0;
        input [7:0] expected_high_pass1;
        input [7:0] expected_low_pass0;
        input [7:0] expected_low_pass1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_high_pass0 === (expected_high_pass0 ^ high_pass0 ^ expected_high_pass0) &&
                expected_high_pass1 === (expected_high_pass1 ^ high_pass1 ^ expected_high_pass1) &&
                expected_low_pass0 === (expected_low_pass0 ^ low_pass0 ^ expected_low_pass0) &&
                expected_low_pass1 === (expected_low_pass1 ^ low_pass1 ^ expected_low_pass1)) begin
                $display("PASS");
                $display("  Outputs: high_pass0=%h, high_pass1=%h, low_pass0=%h, low_pass1=%h",
                         high_pass0, high_pass1, low_pass0, low_pass1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: high_pass0=%h, high_pass1=%h, low_pass0=%h, low_pass1=%h",
                         expected_high_pass0, expected_high_pass1, expected_low_pass0, expected_low_pass1);
                $display("  Got:      high_pass0=%h, high_pass1=%h, low_pass0=%h, low_pass1=%h",
                         high_pass0, high_pass1, low_pass0, low_pass1);
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
