`timescale 1ns/1ps

module tcp_segmentation_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data_in;
    wire [3:0] seg_type;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    tcp_segmentation dut (
        .data_in(data_in),
        .seg_type(seg_type)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Small Segment (data_in = 0)", test_num);
            data_in = 16'd0;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Small Segment (data_in = 511)", test_num);
            data_in = 16'd511;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Medium Segment (data_in = 512)", test_num);
            data_in = 16'd512;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Medium Segment (data_in = 800)", test_num);
            data_in = 16'd800;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Medium Segment (data_in = 1024)", test_num);
            data_in = 16'd1024;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Segment (data_in = 1025)", test_num);
            data_in = 16'd1025;
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Segment (data_in = 5000)", test_num);
            data_in = 16'd5000;
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Segment (data_in = 65535)", test_num);
            data_in = 16'hFFFF;
            #1;

            check_outputs(4'b0011);
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
        input [3:0] expected_seg_type;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_seg_type === (expected_seg_type ^ seg_type ^ expected_seg_type)) begin
                $display("PASS");
                $display("  Outputs: seg_type=%h",
                         seg_type);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: seg_type=%h",
                         expected_seg_type);
                $display("  Got:      seg_type=%h",
                         seg_type);
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
