`timescale 1ns/1ps

module histogram_equalization_tb;

    // Testbench signals (combinational circuit)
    reg [255:0] histogram;
    wire [255:0] equalized_histogram;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    histogram_equalization dut (
        .histogram(histogram),
        .equalized_histogram(equalized_histogram)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All intensity counts zero", test_num);
            histogram = 256'h0;
            #1;

            check_outputs(256'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All intensities present (Uniform)", test_num);
            histogram = {64{4'hF}};
            #1;

            check_outputs({64{4'hF}});
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Two points at extremes (0 and 255)", test_num);

            histogram = 256'h8000000000000000000000000000000000000000000000000000000000000001;
            #1;

            check_outputs(256'h8000000000000000000000000000000000000000000000000000000000000001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Three points (0, 127, 255)", test_num);

            histogram = 256'h8000000000000000000000000000000080000000000000000000000000000001;
            #1;

            check_outputs(256'h8000000000000000000000000000000080000000000000000000000000000001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Dense cluster at low end (0,1,2,3)", test_num);
            histogram = 256'hF;

            #1;


            check_outputs(256'h8000000000000000000004000000000000000000002000000000000000000001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single intensity at 255", test_num);
            histogram = 256'h8000000000000000000000000000000000000000000000000000000000000000;
            #1;

            check_outputs(256'h1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("histogram_equalization Testbench");
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
        input [255:0] expected_equalized_histogram;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_equalized_histogram === (expected_equalized_histogram ^ equalized_histogram ^ expected_equalized_histogram)) begin
                $display("PASS");
                $display("  Outputs: equalized_histogram=%h",
                         equalized_histogram);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: equalized_histogram=%h",
                         expected_equalized_histogram);
                $display("  Got:      equalized_histogram=%h",
                         equalized_histogram);
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
