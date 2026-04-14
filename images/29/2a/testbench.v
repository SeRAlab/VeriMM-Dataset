`timescale 1ns/1ps

module tcp_segmentation_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] segmentation_type;
    reg [15:0] tcp_segment;
    wire [15:0] output_segment;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    tcp_segmentation dut (
        .segmentation_type(segmentation_type),
        .tcp_segment(tcp_segment),
        .output_segment(output_segment)
    );
    task testcase001;

        begin
            $display("Testcase 001: Type 0 (No Segmentation)");
            test_num = test_num + 1;
            tcp_segment = 16'hABCD;
            segmentation_type = 8'd0;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Type 1 (Segment 1)");
            test_num = test_num + 1;
            tcp_segment = 16'h1234;
            segmentation_type = 8'd1;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Type 2 (Segment 2)");
            test_num = test_num + 1;
            tcp_segment = 16'hFFFF;
            segmentation_type = 8'd2;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Type 3 (Segment 3)");
            test_num = test_num + 1;
            tcp_segment = 16'h0001;
            segmentation_type = 8'd3;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Undefined Type (Type 4)");
            test_num = test_num + 1;
            tcp_segment = 16'h55AA;
            segmentation_type = 8'd4;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Max Segmentation Type Boundary");
            test_num = test_num + 1;
            tcp_segment = 16'hCAFE;
            segmentation_type = 8'd255;

            #1;


            check_outputs(16'h0000);
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
        input [15:0] expected_output_segment;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_segment === (expected_output_segment ^ output_segment ^ expected_output_segment)) begin
                $display("PASS");
                $display("  Outputs: output_segment=%h",
                         output_segment);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_segment=%h",
                         expected_output_segment);
                $display("  Got:      output_segment=%h",
                         output_segment);
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
