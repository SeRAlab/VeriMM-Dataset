`timescale 1ns/1ps

module fir_filter_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] x0;
    reg [15:0] x1;
    reg [15:0] x2;
    reg [15:0] x3;
    reg [15:0] x4;
    wire [31:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fir_filter dut (
        .x0(x0),
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .x4(x4),
        .y(y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs zero", test_num);
            x0 = 16'd0; x1 = 16'd0; x2 = 16'd0; x3 = 16'd0; x4 = 16'd0;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Impulse at Tap 0 (x0=100)", test_num);
            x0 = 16'd100; x1 = 16'd0; x2 = 16'd0; x3 = 16'd0; x4 = 16'd0;

            #1;


            check_outputs(32'h00000064);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Impulse at Tap 4 (x4=100)", test_num);
            x0 = 16'd0; x1 = 16'd0; x2 = 16'd0; x3 = 16'd0; x4 = 16'd100;

            #1;


            check_outputs(32'h000001F4);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Uniform DC signal (all x=10)", test_num);
            x0 = 16'd10; x1 = 16'd10; x2 = 16'd10; x3 = 16'd10; x4 = 16'd10;

            #1;


            check_outputs(32'h00000096);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Ramp Input Pattern", test_num);
            x0 = 16'd1; x1 = 16'd2; x2 = 16'd3; x3 = 16'd4; x4 = 16'd5;

            #1;


            check_outputs(32'h00000037);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Input Values (0xFFFF)", test_num);
            x0 = 16'hFFFF; x1 = 16'hFFFF; x2 = 16'hFFFF; x3 = 16'hFFFF; x4 = 16'hFFFF;

            #1;


            check_outputs(32'h000EFFF1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fir_filter Testbench");
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
        input [31:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
