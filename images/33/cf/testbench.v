`timescale 1ns/1ps

module tcp_segmenter_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] mss;
    reg [15:0] payload_size;
    wire [15:0] segment_size;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    tcp_segmenter dut (
        .mss(mss),
        .payload_size(payload_size),
        .segment_size(segment_size),
        .valid(valid)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Payload > MSS", test_num);
            mss = 16'd500;
            payload_size = 16'd1200;
            #1;

            check_outputs(16'd500, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Payload < MSS", test_num);
            mss = 16'd1000;
            payload_size = 16'd350;
            #1;

            check_outputs(16'd350, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Payload == MSS", test_num);
            mss = 16'd1460;
            payload_size = 16'd1460;
            #1;

            check_outputs(16'd1460, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero Payload", test_num);
            mss = 16'd1000;
            payload_size = 16'd0;
            #1;

            check_outputs(16'd0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Minimum MSS", test_num);
            mss = 16'd1;
            payload_size = 16'd10;
            #1;

            check_outputs(16'd1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Large Values", test_num);
            mss = 16'hFFFF;
            payload_size = 16'hFFFF;
            #1;

            check_outputs(16'hFFFF, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Standard Ethernet MSS", test_num);
            mss = 16'd1500;
            payload_size = 16'd4000;
            #1;

            check_outputs(16'd1500, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("tcp_segmenter Testbench");
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
        input [15:0] expected_segment_size;
        input expected_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_segment_size === (expected_segment_size ^ segment_size ^ expected_segment_size) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: segment_size=%h, valid=%b",
                         segment_size, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: segment_size=%h, valid=%b",
                         expected_segment_size, expected_valid);
                $display("  Got:      segment_size=%h, valid=%b",
                         segment_size, valid);
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
