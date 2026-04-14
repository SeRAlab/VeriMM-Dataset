`timescale 1ns/1ps

module tcp_segmentation_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] segment_size;
    wire [2:0] segmentation_type;

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
        test_num = test_num + 1;
        $display("Test Case %0d: size=0 (Range <= 64)", test_num);
        segment_size = 16'd0;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: size=64 (Range <= 64 boundary)", test_num);
        segment_size = 16'd64;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: size=65 (Range 65-128 boundary)", test_num);
        segment_size = 16'd65;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: size=100 (Range 65-128)", test_num);
        segment_size = 16'd100;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: size=128 (Range 65-128 boundary)", test_num);
        segment_size = 16'd128;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: size=129 (Range 129-256 boundary)", test_num);
        segment_size = 16'd129;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: size=200 (Range 129-256)", test_num);
        segment_size = 16'd200;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: size=256 (Range 129-256 boundary)", test_num);
        segment_size = 16'd256;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: size=257 (Range > 256 boundary)", test_num);
        segment_size = 16'd257;
        #1;

        check_outputs(3'b011);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: size=65535 (Range > 256 max input)", test_num);
        segment_size = 16'hFFFF;
        #1;

        check_outputs(3'b011);
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
        input [2:0] expected_segmentation_type;
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
