`timescale 1ns/1ps

module morphological_dilation_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] img_in;
    wire img_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    morphological_dilation dut (
        .img_in(img_in),
        .img_out(img_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All zeros - Expecting 0", test_num);
        img_in = 9'b000_000_000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All ones - Expecting 1", test_num);
        img_in = 9'b111_111_111;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Single bit at index 0 - Expecting 1", test_num);
        img_in = 9'b000_000_001;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Single bit at index 8 - Expecting 1", test_num);
        img_in = 9'b100_000_000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Single bit at center (index 4) - Expecting 1", test_num);
        img_in = 9'b000_010_000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Top row only - Expecting 1", test_num);
        img_in = 9'b000_000_111;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Checkerboard pattern - Expecting 1", test_num);
        img_in = 9'b101_010_101;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bottom right corner - Expecting 1", test_num);
        img_in = 9'b100_000_000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Two bits set - Expecting 1", test_num);
        img_in = 9'b010_000_010;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Sparse bits - Expecting 1", test_num);
        img_in = 9'b001_000_100;
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
        input expected_img_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_img_out === (expected_img_out ^ img_out ^ expected_img_out)) begin
                $display("PASS");
                $display("  Outputs: img_out=%b",
                         img_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: img_out=%b",
                         expected_img_out);
                $display("  Got:      img_out=%b",
                         img_out);
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
