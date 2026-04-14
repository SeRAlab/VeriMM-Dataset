`timescale 1ns/1ps

module tcp_segmentation_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] mss;
    reg [15:0] segment_length;
    wire [3:0] num_segments;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    tcp_segmentation dut (
        .mss(mss),
        .segment_length(segment_length),
        .num_segments(num_segments)
    );
    task testcase001;

    begin
        test_num = 1;
        segment_length = 16'd500;
        mss = 16'd1000;
        $display("Test %0d: segment_length=500, mss=1000 (Length < MSS)", test_num);
        #1;

        check_outputs(4'd1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        segment_length = 16'd1000;
        mss = 16'd1000;
        $display("Test %0d: segment_length=1000, mss=1000 (Length == MSS)", test_num);
        #1;

        check_outputs(4'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        segment_length = 16'd1001;
        mss = 16'd1000;
        $display("Test %0d: segment_length=1001, mss=1000 (One full + one partial)", test_num);
        #1;

        check_outputs(4'd2);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        segment_length = 16'd2000;
        mss = 16'd1000;
        $display("Test %0d: segment_length=2000, mss=1000 (Exactly two full segments)", test_num);
        #1;

        check_outputs(4'd2);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        segment_length = 16'd15000;
        mss = 16'd1000;
        $display("Test %0d: segment_length=15000, mss=1000 (Exactly 15 segments)", test_num);
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        segment_length = 16'd7500;
        mss = 16'd1000;
        $display("Test %0d: segment_length=7500, mss=1000 (7 full + 1 partial = 8)", test_num);
        #1;

        check_outputs(4'd8);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        segment_length = 16'd4000;
        mss = 16'd1460;
        $display("Test %0d: segment_length=4000, mss=1460 (2 full + 1 partial = 3)", test_num);
        #1;

        check_outputs(4'd3);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        segment_length = 16'd10;
        mss = 16'd65535;
        $display("Test %0d: segment_length=10, mss=65535 (Length << MSS)", test_num);
        #1;

        check_outputs(4'd1);
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
        input [3:0] expected_num_segments;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_num_segments === (expected_num_segments ^ num_segments ^ expected_num_segments)) begin
                $display("PASS");
                $display("  Outputs: num_segments=%h",
                         num_segments);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: num_segments=%h",
                         expected_num_segments);
                $display("  Got:      num_segments=%h",
                         num_segments);
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
