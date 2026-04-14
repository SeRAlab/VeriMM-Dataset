`timescale 1ns/1ps

module sobel_edge_detector_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] pixels;
    wire edge_detected;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sobel_edge_detector dut (
        .pixels(pixels),
        .edge_detected(edge_detected)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All zeros", test_num);
            pixels = 9'b000_000_000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All ones", test_num);
            pixels = 9'b111_111_111;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Vertical edge (left)", test_num);
            pixels = 9'b100_100_100;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Vertical edge (right)", test_num);
            pixels = 9'b001_001_001;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Horizontal edge (top)", test_num);
            pixels = 9'b111_000_000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Horizontal edge (bottom)", test_num);
            pixels = 9'b000_000_111;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Center pixel only", test_num);
            pixels = 9'b000_010_000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Corner block", test_num);
            pixels = 9'b110_110_000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Checkerboard", test_num);
            pixels = 9'b101_010_101;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Top-Right block", test_num);
            pixels = 9'b011_011_000;
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
        $display("sobel_edge_detector Testbench");
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
