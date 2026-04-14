`timescale 1ns/1ps

module monte_carlo_pi_tb;

    // Testbench signals (combinational circuit)
    reg throw;
    reg [7:0] x;
    reg [7:0] y;
    wire [31:0] count;
    wire inside;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    monte_carlo_pi dut (
        .throw(throw),
        .x(x),
        .y(y),
        .count(count),
        .inside(inside)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Origin (0,0) - Should be inside", test_num);
        x = 8'd0;
        y = 8'd0;
        throw = 1;
        #10;
        #1;

        check_outputs(32'd1, 1'b1);
        throw = 0;
        #10;
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Top-right corner (255,255) - Should be outside", test_num);
        x = 8'd255;
        y = 8'd255;
        throw = 1;
        #10;
        #1;

        check_outputs(32'd2, 1'b0);
        throw = 0;
        #10;
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Boundary point (255,0) - Should be inside", test_num);
        x = 8'd255;
        y = 8'd0;
        throw = 1;
        #10;
        #1;

        check_outputs(32'd3, 1'b1);
        throw = 0;
        #10;
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Boundary point (0,255) - Should be inside", test_num);
        x = 8'd0;
        y = 8'd255;
        throw = 1;
        #10;
        #1;

        check_outputs(32'd4, 1'b1);
        throw = 0;
        #10;
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Center point (128,128) - Should be inside", test_num);

        x = 8'd128;
        y = 8'd128;
        throw = 1;
        #10;
        #1;

        check_outputs(32'd5, 1'b1);
        throw = 0;
        #10;
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Near-edge outside (200,160) - Should be outside", test_num);

        x = 8'd200;
        y = 8'd160;
        throw = 1;
        #10;
        #1;

        check_outputs(32'd6, 1'b0);
        throw = 0;
        #10;
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Near-edge inside (180,180) - Should be inside", test_num);

        x = 8'd180;
        y = 8'd180;
        throw = 1;
        #10;
        #1;

        check_outputs(32'd7, 1'b1);
        throw = 0;
        #10;
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
        input [31:0] expected_count;
        input expected_inside;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_inside === (expected_inside ^ inside ^ expected_inside)) begin
                $display("PASS");
                $display("  Outputs: count=%h, inside=%b",
                         count, inside);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, inside=%b",
                         expected_count, expected_inside);
                $display("  Got:      count=%h, inside=%b",
                         count, inside);
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
