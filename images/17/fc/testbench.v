`timescale 1ns/1ps

module knn_classifier_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] in_data;
    wire [1:0] nearest_neighbor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    knn_classifier dut (
        .in_data(in_data),
        .nearest_neighbor(nearest_neighbor)
    );
    task testcase001;

        begin
            test_num = 1;
            in_data = 5'd0;
            #10;

            #1;


            check_outputs(2'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in_data = 5'd1;
            #10;
            #1;

            check_outputs(2'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in_data = 5'd2;
            #10;
            #1;

            check_outputs(2'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in_data = 5'd3;
            #10;
            #1;

            check_outputs(2'd3);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            in_data = 5'd4;
            #10;
            #1;

            check_outputs(2'd3);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            in_data = 5'd31;
            #10;


            #1;



            check_outputs(2'd3);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            in_data = 5'd7;
            #10;
            #1;

            check_outputs(2'd3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("knn_classifier Testbench");
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
        input [1:0] expected_nearest_neighbor;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_nearest_neighbor === (expected_nearest_neighbor ^ nearest_neighbor ^ expected_nearest_neighbor)) begin
                $display("PASS");
                $display("  Outputs: nearest_neighbor=%h",
                         nearest_neighbor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: nearest_neighbor=%h",
                         expected_nearest_neighbor);
                $display("  Got:      nearest_neighbor=%h",
                         nearest_neighbor);
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
