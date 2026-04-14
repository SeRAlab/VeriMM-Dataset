`timescale 1ns/1ps

module morphological_dilation_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] img;
    reg [8:0] struct_elem;
    wire result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    morphological_dilation dut (
        .img(img),
        .struct_elem(struct_elem),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: All zeros", test_num);
        img = 9'b000_000_000;
        struct_elem = 9'b000_000_000;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Image all ones, Structuring Element all zeros", test_num);
        img = 9'b111_111_111;
        struct_elem = 9'b000_000_000;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Image all zeros, Structuring Element all ones", test_num);
        img = 9'b000_000_000;
        struct_elem = 9'b111_111_111;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Center pixel overlap only", test_num);
        img = 9'b000_010_000;
        struct_elem = 9'b000_010_000;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Top-left pixel overlap only", test_num);
        img = 9'b100_000_000;
        struct_elem = 9'b100_000_000;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Bottom-right pixel overlap only", test_num);
        img = 9'b000_000_001;
        struct_elem = 9'b000_000_001;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Image and SE have pixels but no overlap", test_num);
        img = 9'b101_010_101;
        struct_elem = 9'b010_101_010;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Checkerboard overlap at one pixel", test_num);
        img = 9'b101_010_101;
        struct_elem = 9'b111_111_111;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: Sparse image, dense SE", test_num);
        img = 9'b000_000_100;
        struct_elem = 9'h1FF;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: Single bit mismatch", test_num);
        img = 9'b000_000_010;
        struct_elem = 9'b101_111_101;
        #1;

        check_outputs(0);
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
        input expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%b",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%b",
                         expected_result);
                $display("  Got:      result=%b",
                         result);
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
