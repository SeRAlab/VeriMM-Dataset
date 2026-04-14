`timescale 1ns/1ps

module k_means_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] cx;
    reg [7:0] cy;
    reg [7:0] x;
    reg [7:0] y;
    wire [1:0] index;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    k_means dut (
        .cx(cx),
        .cy(cy),
        .x(x),
        .y(y),
        .index(index)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Exact match with input centroid", test_num);
            cx = 8'd100;
            cy = 8'd100;
            x = 8'd100;
            y = 8'd100;
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Closer to origin than input centroid", test_num);
            cx = 8'd200;
            cy = 8'd200;
            x = 8'd5;
            y = 8'd5;
            #1;

            check_outputs(2'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Closer to (255, 0) region", test_num);
            cx = 8'd20;
            cy = 8'd20;
            x = 8'd250;
            y = 8'd10;
            #1;

            check_outputs(2'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Closer to (255, 255) region", test_num);
            cx = 8'd50;
            cy = 8'd50;
            x = 8'd240;
            y = 8'd240;
            #1;

            check_outputs(2'd3);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary values close to cx,cy", test_num);
            cx = 8'd128;
            cy = 8'd128;
            x = 8'd130;
            y = 8'd126;
            #1;

            check_outputs(2'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("k_means Testbench");
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
        input [1:0] expected_index;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_index === (expected_index ^ index ^ expected_index)) begin
                $display("PASS");
                $display("  Outputs: index=%h",
                         index);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: index=%h",
                         expected_index);
                $display("  Got:      index=%h",
                         index);
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
