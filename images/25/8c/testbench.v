`timescale 1ns/1ps

module tcp_segmentation_type_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] segment_length;
    wire [2:0] segment_type;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    tcp_segmentation_type dut (
        .segment_length(segment_length),
        .segment_type(segment_type)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary check - Minimum segment length (0)", test_num);
            segment_length = 16'd0;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Segment length in Short range (32)", test_num);
            segment_length = 16'd32;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary check - Upper Short limit (64)", test_num);
            segment_length = 16'd64;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary check - Lower Medium limit (65)", test_num);
            segment_length = 16'd65;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Segment length in Medium range (100)", test_num);
            segment_length = 16'd100;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary check - Upper Medium limit (128)", test_num);
            segment_length = 16'd128;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary check - Lower Long limit (129)", test_num);
            segment_length = 16'd129;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Segment length in Long range (500)", test_num);
            segment_length = 16'd500;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary check - Maximum 16-bit length (65535)", test_num);
            segment_length = 16'hFFFF;
            #1;

            check_outputs(3'b010);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("tcp_segmentation_type Testbench");
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
        input [2:0] expected_segment_type;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_segment_type === (expected_segment_type ^ segment_type ^ expected_segment_type)) begin
                $display("PASS");
                $display("  Outputs: segment_type=%h",
                         segment_type);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: segment_type=%h",
                         expected_segment_type);
                $display("  Got:      segment_type=%h",
                         segment_type);
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
