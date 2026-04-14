`timescale 1ns/1ps

module canny_edge_detection_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] pixels;
    reg [3:0] threshold;
    wire edge_detected;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    canny_edge_detection dut (
        .pixels(pixels),
        .threshold(threshold),
        .edge_detected(edge_detected)
    );
    task testcase001;

        begin
            test_num = 1;
            pixels = 9'b000_000_000;
            threshold = 4'd1;
            $display("Testcase %03d: All pixels black (Expected: 0)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            pixels = 9'b001_001_001;
            threshold = 4'd2;
            $display("Testcase %03d: Vertical line (Expected: 1)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            pixels = 9'b000_000_111;
            threshold = 4'd2;
            $display("Testcase %03d: Horizontal line (Expected: 1)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            pixels = 9'b111_111_111;
            threshold = 4'd1;
            $display("Testcase %03d: All pixels white (Expected: 0)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            pixels = 9'b001_001_001;
            threshold = 4'd8;
            $display("Testcase %03d: Edge suppressed by high threshold (Expected: 0)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            pixels = 9'b100_010_001;
            threshold = 4'd2;
            $display("Testcase %03d: Diagonal pattern (Expected: 1)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            pixels = 9'b000_010_000;
            threshold = 4'd1;
            $display("Testcase %03d: Isolated center pixel (Expected: 0)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("canny_edge_detection Testbench");
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
        input expected_edge_detected;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_edge_detected === (expected_edge_detected ^ edge_detected ^ expected_edge_detected)) begin
                $display("PASS");
                $display("  Outputs: edge_detected=%b",
                         edge_detected);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: edge_detected=%b",
                         expected_edge_detected);
                $display("  Got:      edge_detected=%b",
                         edge_detected);
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
