`timescale 1ns/1ps

module tcp_segmentation_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] MSS;
    reg [7:0] segment_size;
    wire segmentation_required;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    tcp_segmentation dut (
        .MSS(MSS),
        .segment_size(segment_size),
        .segmentation_required(segmentation_required)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Equal Values", test_num);
        MSS = 8'd100;
        segment_size = 8'd100;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Segment size < MSS", test_num);
        MSS = 8'd200;
        segment_size = 8'd50;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Segment size > MSS", test_num);
        MSS = 8'd64;
        segment_size = 8'd128;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Segment size = MSS + 1", test_num);
        MSS = 8'd150;
        segment_size = 8'd151;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Both zero", test_num);
        MSS = 8'd0;
        segment_size = 8'd0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: MSS zero, segment non-zero", test_num);
        MSS = 8'd0;
        segment_size = 8'd1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Both maximum (255)", test_num);
        MSS = 8'hFF;
        segment_size = 8'hFF;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Max segment, small MSS", test_num);
        MSS = 8'd10;
        segment_size = 8'hFF;
        #1;

        check_outputs(1'b1);
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
        input expected_segmentation_required;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_segmentation_required === (expected_segmentation_required ^ segmentation_required ^ expected_segmentation_required)) begin
                $display("PASS");
                $display("  Outputs: segmentation_required=%b",
                         segmentation_required);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: segmentation_required=%b",
                         expected_segmentation_required);
                $display("  Got:      segmentation_required=%b",
                         segmentation_required);
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
