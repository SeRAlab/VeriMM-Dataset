`timescale 1ns/1ps

module monte_carlo_pi_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] x0;
    reg [31:0] x1;
    reg [31:0] x2;
    reg [31:0] x3;
    reg [31:0] x4;
    reg [31:0] y0;
    reg [31:0] y1;
    reg [31:0] y2;
    reg [31:0] y3;
    reg [31:0] y4;
    wire [2:0] inside_count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    monte_carlo_pi dut (
        .x0(x0),
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .x4(x4),
        .y0(y0),
        .y1(y1),
        .y2(y2),
        .y3(y3),
        .y4(y4),
        .inside_count(inside_count)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: All points at origin", test_num);
        x0 = 32'd0; y0 = 32'd0;
        x1 = 32'd0; y1 = 32'd0;
        x2 = 32'd0; y2 = 32'd0;
        x3 = 32'd0; y3 = 32'd0;
        x4 = 32'd0; y4 = 32'd0;
        #1;

        check_outputs(3'd5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: All points outside", test_num);
        x0 = OUT_OF_BOUNDS; y0 = OUT_OF_BOUNDS;
        x1 = OUT_OF_BOUNDS; y1 = OUT_OF_BOUNDS;
        x2 = OUT_OF_BOUNDS; y2 = OUT_OF_BOUNDS;
        x3 = OUT_OF_BOUNDS; y3 = OUT_OF_BOUNDS;
        x4 = OUT_OF_BOUNDS; y4 = OUT_OF_BOUNDS;
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Mixed boundary conditions", test_num);
        x0 = UNIT;   y0 = 32'd0;
        x1 = 32'd0;  y1 = UNIT;
        x2 = HALF;   y2 = HALF;
        x3 = UNIT;   y3 = 32'd100;
        x4 = OUT_OF_BOUNDS; y4 = 32'd0;
        #1;

        check_outputs(3'd3);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Diagonal precision check", test_num);
        x0 = DIAG_IN;  y0 = DIAG_IN;
        x1 = DIAG_OUT; y1 = DIAG_OUT;
        x2 = DIAG_IN;  y2 = DIAG_IN;
        x3 = DIAG_OUT; y3 = DIAG_OUT;
        x4 = 32'd0;    y4 = 32'd0;
        #1;

        check_outputs(3'd3);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Symmetry test", test_num);
        x0 = 32'd1000; y0 = UNIT;
        x1 = UNIT;     y1 = 32'd1000;
        x2 = 32'd0;    y2 = OUT_OF_BOUNDS;
        x3 = OUT_OF_BOUNDS; y3 = 32'd0;
        x4 = HALF;     y4 = HALF;
        #1;

        check_outputs(3'd3);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("monte_carlo_pi Testbench");
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
        input [2:0] expected_inside_count;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_inside_count === (expected_inside_count ^ inside_count ^ expected_inside_count)) begin
                $display("PASS");
                $display("  Outputs: inside_count=%h",
                         inside_count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: inside_count=%h",
                         expected_inside_count);
                $display("  Got:      inside_count=%h",
                         inside_count);
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
