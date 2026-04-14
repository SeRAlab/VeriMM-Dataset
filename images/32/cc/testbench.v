`timescale 1ns/1ps

module linked_list_traversal_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] index;
    wire [7:0] node_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linked_list_traversal dut (
        .index(index),
        .node_value(node_value)
    );
    task testcase001;

        begin
            test_num = 1;
            index = 3'd0;


            #1;



            check_outputs(8'h0A);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            index = 3'd1;
            #1;

            check_outputs(8'h14);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            index = 3'd2;
            #1;

            check_outputs(8'h1E);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            index = 3'd3;
            #1;

            check_outputs(8'h28);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            index = 3'd4;
            #1;

            check_outputs(8'h32);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            index = 3'd5;
            #1;

            check_outputs(8'h3C);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            index = 3'd6;
            #1;

            check_outputs(8'h46);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            index = 3'd7;
            #1;

            check_outputs(8'h50);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("linked_list_traversal Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [7:0] expected_node_value;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_node_value === (expected_node_value ^ node_value ^ expected_node_value)) begin
                $display("PASS");
                $display("  Outputs: node_value=%h",
                         node_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: node_value=%h",
                         expected_node_value);
                $display("  Got:      node_value=%h",
                         node_value);
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
