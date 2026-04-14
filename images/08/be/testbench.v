`timescale 1ns/1ps

module morphological_dilation_tb;

    // Testbench signals (combinational circuit)
    reg [24:0] image_in;
    wire [24:0] image_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    morphological_dilation dut (
        .image_in(image_in),
        .image_out(image_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Background", test_num);
        image_in = 25'h0000000;
        #1;

        check_outputs(25'h0000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Center Pixel Dilation", test_num);
        image_in = 25'h0001000;
        #1;

        check_outputs(25'h00739C0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Top-Left Corner Dilation", test_num);
        image_in = 25'h0000001;
        #1;

        check_outputs(25'h0000063);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bottom-Right Corner Dilation", test_num);
        image_in = 25'h1000000;
        #1;

        check_outputs(25'h18C0000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Horizontal Line Dilation", test_num);
        image_in = 25'h0007C00;
        #1;

        check_outputs(25'h00FFFE0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Vertical Line Dilation", test_num);
        image_in = 25'h0421084;
        #1;

        check_outputs(25'h0ED39CE);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Checkerboard Pattern Dilation", test_num);
        image_in = 25'h0AAB2AA;
        #1;

        check_outputs(25'h1FFFFFF);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Foreground", test_num);
        image_in = 25'h1FFFFFF;
        #1;

        check_outputs(25'h1FFFFFF);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("morphological_dilation Testbench");
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
        input [24:0] expected_image_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_image_out === (expected_image_out ^ image_out ^ expected_image_out)) begin
                $display("PASS");
                $display("  Outputs: image_out=%h",
                         image_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: image_out=%h",
                         expected_image_out);
                $display("  Got:      image_out=%h",
                         image_out);
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
