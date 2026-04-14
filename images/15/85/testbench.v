`timescale 1ns/1ps

module tcp_segmentation_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] segment_size;
    reg [1:0] segmentation_type;
    wire [15:0] adjusted_size;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    tcp_segmentation dut (
        .segment_size(segment_size),
        .segmentation_type(segmentation_type),
        .adjusted_size(adjusted_size)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: No Segmentation", test_num);
        segment_size = 16'd1500;
        segmentation_type = 2'b00;
        #1;

        check_outputs(16'd1500);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: MSS Adjustment", test_num);
        segment_size = 16'd1500;
        segmentation_type = 2'b01;
        #1;

        check_outputs(16'd1480);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: SACK Adjustment", test_num);
        segment_size = 16'd1500;
        segmentation_type = 2'b10;
        #1;

        check_outputs(16'd1468);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: PMTUD Adjustment", test_num);
        segment_size = 16'd1500;
        segmentation_type = 2'b11;
        #1;

        check_outputs(16'd1460);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: No Segmentation (Small Size)", test_num);
        segment_size = 16'd1000;
        segmentation_type = 2'b00;
        #1;

        check_outputs(16'd1000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: MSS Adjustment (Small Size)", test_num);
        segment_size = 16'd1000;
        segmentation_type = 2'b01;
        #1;

        check_outputs(16'd980);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: SACK Adjustment (Edge Case)", test_num);
        segment_size = 16'd64;
        segmentation_type = 2'b10;
        #1;

        check_outputs(16'd32);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: PMTUD Adjustment (Max Size)", test_num);
        segment_size = 16'hFFFF;
        segmentation_type = 2'b11;
        #1;

        check_outputs(16'hFFFF - 16'd40);
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
        input [15:0] expected_adjusted_size;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_adjusted_size === (expected_adjusted_size ^ adjusted_size ^ expected_adjusted_size)) begin
                $display("PASS");
                $display("  Outputs: adjusted_size=%h",
                         adjusted_size);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: adjusted_size=%h",
                         expected_adjusted_size);
                $display("  Got:      adjusted_size=%h",
                         adjusted_size);
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
