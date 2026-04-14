`timescale 1ns/1ps

module tcp_segmentation_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] mss;
    reg [15:0] tcp_segment_size;
    wire [15:0] actual_segment_size;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    tcp_segmentation dut (
        .mss(mss),
        .tcp_segment_size(tcp_segment_size),
        .actual_segment_size(actual_segment_size)
    );
    task testcase001;

        begin
            test_num = 1;
            mss = 16'd1460;
            tcp_segment_size = 16'd1000;
            $display("Testcase %0d: TCP size < MSS (Normal Case)", test_num);
            #1;

            check_outputs(16'd1000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            mss = 16'd1460;
            tcp_segment_size = 16'd2000;
            $display("Testcase %0d: TCP size > MSS (Capping Case)", test_num);
            #1;

            check_outputs(16'd1460);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            mss = 16'd1460;
            tcp_segment_size = 16'd1460;
            $display("Testcase %0d: TCP size == MSS (Boundary Case)", test_num);
            #1;

            check_outputs(16'd1460);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            mss = 16'hFFFF;
            tcp_segment_size = 16'hFFFF;
            $display("Testcase %0d: Both at Maximum Value", test_num);
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            mss = 16'd0;
            tcp_segment_size = 16'd500;
            $display("Testcase %0d: MSS is Zero", test_num);
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            mss = 16'd1000;
            tcp_segment_size = 16'd0;
            $display("Testcase %0d: TCP size is Zero", test_num);
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            mss = 16'h0001;
            tcp_segment_size = 16'hFFFF;
            $display("Testcase %0d: Minimum MSS, Maximum TCP size", test_num);
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            mss = 16'h8000;
            tcp_segment_size = 16'h7FFF;
            $display("Testcase %0d: Large values, No Capping", test_num);
            #1;

            check_outputs(16'h7FFF);
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
        input [15:0] expected_actual_segment_size;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_actual_segment_size === (expected_actual_segment_size ^ actual_segment_size ^ expected_actual_segment_size)) begin
                $display("PASS");
                $display("  Outputs: actual_segment_size=%h",
                         actual_segment_size);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: actual_segment_size=%h",
                         expected_actual_segment_size);
                $display("  Got:      actual_segment_size=%h",
                         actual_segment_size);
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
