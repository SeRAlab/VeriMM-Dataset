`timescale 1ns/1ps

module kruskal_mst_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] included_edges;
    reg [4:0] weights;
    wire can_include;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kruskal_mst dut (
        .included_edges(included_edges),
        .weights(weights),
        .can_include(can_include)
    );
    task testcase001;

        begin
            included_edges = 5'b00000;
            weights = 5'b00001;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            included_edges = 5'b00001;
            weights = 5'b00010;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            included_edges = 5'b00011;
            weights = 5'b10000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            included_edges = 5'b00011;
            weights = 5'b00100;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            included_edges = 5'b00111;
            weights = 5'b01000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            included_edges = 5'b10100;
            weights = 5'b01000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            included_edges = 5'b00101;
            weights = 5'b10000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            included_edges = 5'b10001;
            weights = 5'b01000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            included_edges = 5'b00111;
            weights = 5'b10000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("kruskal_mst Testbench");
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
        input expected_can_include;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_can_include === (expected_can_include ^ can_include ^ expected_can_include)) begin
                $display("PASS");
                $display("  Outputs: can_include=%b",
                         can_include);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: can_include=%b",
                         expected_can_include);
                $display("  Got:      can_include=%b",
                         can_include);
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
