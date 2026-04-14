`timescale 1ns/1ps

module tcp_segmentation_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] payload_length;
    wire [15:0] last_segment_size;
    wire [15:0] num_segments;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    tcp_segmentation dut (
        .payload_length(payload_length),
        .last_segment_size(last_segment_size),
        .num_segments(num_segments)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero payload length", test_num);
            payload_length = 16'd0;

            #1;


            check_outputs(16'd0, 16'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Small payload (less than MSS)", test_num);
            payload_length = 16'd500;

            #1;


            check_outputs(16'd500, 16'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Payload exactly equal to MSS", test_num);
            payload_length = 16'd1460;

            #1;


            check_outputs(16'd1460, 16'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Payload just over MSS (1461 bytes)", test_num);
            payload_length = 16'd1461;

            #1;


            check_outputs(16'd1, 16'd2);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Payload exactly double MSS (2920 bytes)", test_num);
            payload_length = 16'd2920;

            #1;


            check_outputs(16'd1460, 16'd2);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random large payload (5000 bytes)", test_num);
            payload_length = 16'd5000;


            #1;



            check_outputs(16'd620, 16'd4);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum 16-bit payload (65535 bytes)", test_num);
            payload_length = 16'hFFFF;



            #1;




            check_outputs(16'd1315, 16'd45);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Minimum non-zero payload", test_num);
            payload_length = 16'd1;

            #1;


            check_outputs(16'd1, 16'd1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple of MSS (4380 bytes)", test_num);
            payload_length = 16'd4380;

            #1;


            check_outputs(16'd1460, 16'd3);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Arbitrary payload (3000 bytes)", test_num);
            payload_length = 16'd3000;


            #1;



            check_outputs(16'd80, 16'd3);
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
        input [15:0] expected_last_segment_size;
        input [15:0] expected_num_segments;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_last_segment_size === (expected_last_segment_size ^ last_segment_size ^ expected_last_segment_size) &&
                expected_num_segments === (expected_num_segments ^ num_segments ^ expected_num_segments)) begin
                $display("PASS");
                $display("  Outputs: last_segment_size=%h, num_segments=%h",
                         last_segment_size, num_segments);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: last_segment_size=%h, num_segments=%h",
                         expected_last_segment_size, expected_num_segments);
                $display("  Got:      last_segment_size=%h, num_segments=%h",
                         last_segment_size, num_segments);
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
