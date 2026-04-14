`timescale 1ns/1ps

module fir_filter_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] x0;
    reg [3:0] x1;
    reg [3:0] x2;
    reg [3:0] x3;
    wire [7:0] y;

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
        .y(y)
    );
    task testcase001;

    begin
        $display("\nRunning testcase001: All Zeros");
        x0 = 0; x1 = 0; x2 = 0; x3 = 0;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase002;

    begin
        $display("\nRunning testcase002: Unit Impulse (Most Recent)");
        x0 = 1; x1 = 0; x2 = 0; x3 = 0;
        #1;

        check_outputs(8'd4);
    end
        endtask

    task testcase003;

    begin
        $display("\nRunning testcase003: Unit Impulse (Oldest)");
        x0 = 0; x1 = 0; x2 = 0; x3 = 1;
        #1;

        check_outputs(8'd1);
    end
        endtask

    task testcase004;

    begin
        $display("\nRunning testcase004: All Ones (Minimum Signal)");
        x0 = 1; x1 = 1; x2 = 1; x3 = 1;
        #1;

        check_outputs(8'd10);
    end
        endtask

    task testcase005;

    begin
        $display("\nRunning testcase005: Max Values (Saturation Check)");
        x0 = 15; x1 = 15; x2 = 15; x3 = 15;

        #1;


        check_outputs(8'd150);
    end
        endtask

    task testcase006;

    begin
        $display("\nRunning testcase006: Sequential Pattern");
        x0 = 2; x1 = 4; x2 = 6; x3 = 8;

        #1;


        check_outputs(8'd40);
    end
        endtask

    task testcase007;

    begin
        $display("\nRunning testcase007: Alternating Values");
        x0 = 5; x1 = 10; x2 = 5; x3 = 10;

        #1;


        check_outputs(8'd70);
    end
        endtask

    task testcase008;

    begin
        $display("\nRunning testcase008: Middle Tap Dominance");
        x0 = 0; x1 = 15; x2 = 15; x3 = 0;

        #1;


        check_outputs(8'd75);
    end
        endtask

    task testcase009;

    begin
        $display("\nRunning testcase009: Falling Gradient");
        x0 = 10; x1 = 8; x2 = 6; x3 = 4;

        #1;


        check_outputs(8'd80);
    end
        endtask

    task testcase010;

    begin
        $display("\nRunning testcase010: Rising Gradient");
        x0 = 4; x1 = 6; x2 = 8; x3 = 10;

        #1;


        check_outputs(8'd60);
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
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [7:0] expected_y;
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
