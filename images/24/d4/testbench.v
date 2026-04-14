`timescale 1ns/1ps

module LinkedListTraversal_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] index;
    wire [7:0] value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LinkedListTraversal dut (
        .index(index),
        .value(value)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Accessing index 0", test_num);
            index = 4'd0;


            #1;



            check_outputs(8'h0A);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Accessing index 1", test_num);
            index = 4'd1;

            #1;


            check_outputs(8'h14);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Accessing index 2", test_num);
            index = 4'd2;

            #1;


            check_outputs(8'h1E);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Accessing index 3", test_num);
            index = 4'd3;

            #1;


            check_outputs(8'h28);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Accessing out-of-bounds index 15", test_num);
            index = 4'd15;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Accessing out-of-bounds index 8", test_num);
            index = 4'd8;

            #1;


            check_outputs(8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LinkedListTraversal Testbench");
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
        input [7:0] expected_value;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_value === (expected_value ^ value ^ expected_value)) begin
                $display("PASS");
                $display("  Outputs: value=%h",
                         value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: value=%h",
                         expected_value);
                $display("  Got:      value=%h",
                         value);
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
