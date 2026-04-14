`timescale 1ns/1ps

module tcp_segmentation_tb;

    // Testbench signals (combinational circuit)
    reg [11:0] segment_size;
    wire [7:0] segmentation_type;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    tcp_segmentation dut (
        .segment_size(segment_size),
        .segmentation_type(segmentation_type)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Size 0 (Small)", test_num);
            segment_size = 12'd0;
            #1;

            check_outputs(8'h53);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Size 536 (Small Boundary)", test_num);
            segment_size = 12'd536;
            #1;

            check_outputs(8'h53);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Size 537 (Medium Boundary)", test_num);
            segment_size = 12'd537;
            #1;

            check_outputs(8'h4D);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Size 1000 (Medium)", test_num);
            segment_size = 12'd1000;
            #1;

            check_outputs(8'h4D);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Size 1460 (Medium Boundary)", test_num);
            segment_size = 12'd1460;
            #1;

            check_outputs(8'h4D);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Size 1461 (Large Boundary)", test_num);
            segment_size = 12'd1461;
            #1;

            check_outputs(8'h4C);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Size 4095 (Large Max)", test_num);
            segment_size = 12'd4095;
            #1;

            check_outputs(8'h4C);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("tcp_segmentation Testbench");
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
        input [7:0] expected_segmentation_type;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_segmentation_type === (expected_segmentation_type ^ segmentation_type ^ expected_segmentation_type)) begin
                $display("PASS");
                $display("  Outputs: segmentation_type=%h",
                         segmentation_type);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: segmentation_type=%h",
                         expected_segmentation_type);
                $display("  Got:      segmentation_type=%h",
                         segmentation_type);
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
