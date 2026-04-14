`timescale 1ns/1ps

module graph_coloring_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] edges;
    wire [1:0] color;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    graph_coloring dut (
        .edges(edges),
        .color(color)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: No edges connected", test_num);
            edges = 5'b00000;
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Edge to color 0", test_num);
            edges = 5'b00001;
            #1;

            check_outputs(2'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Edges to colors 0 and 1", test_num);
            edges = 5'b00011;
            #1;

            check_outputs(2'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Edges to colors 0, 1, and 2", test_num);
            edges = 5'b00111;
            #1;

            check_outputs(2'd3);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Edge to color 1 only (0 is free)", test_num);
            edges = 5'b00010;
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Edges to colors 0 and 2 (1 is free)", test_num);
            edges = 5'b00101;
            #1;

            check_outputs(2'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Edges to colors 1, 2, 3 (0 is free)", test_num);
            edges = 5'b01110;
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Bit 4 edge constraint", test_num);
            edges = 5'b10000;


            #1;



            check_outputs(2'd0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: All 4 base colors blocked", test_num);
            edges = 5'b01111;


            #1;



            check_outputs(2'd0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Color 3 blocked", test_num);
            edges = 5'b01000;
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
        $display("graph_coloring Testbench");
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
        input [1:0] expected_color;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_color === (expected_color ^ color ^ expected_color)) begin
                $display("PASS");
                $display("  Outputs: color=%h",
                         color);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: color=%h",
                         expected_color);
                $display("  Got:      color=%h",
                         color);
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
