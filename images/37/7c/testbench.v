`timescale 1ns/1ps

module merge_sort_4bit_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] arr;
    wire [3:0] sorted;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    merge_sort_4bit dut (
        .arr(arr),
        .sorted(sorted)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Zeros", test_num);
        arr = 4'b0000;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Ones", test_num);
        arr = 4'b1111;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Single One at MSB", test_num);
        arr = 4'b1000;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Single One at LSB", test_num);
        arr = 4'b0001;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Two Ones (MSB and LSB)", test_num);
        arr = 4'b1001;
        #1;

        check_outputs(4'b0011);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Two Ones (Alternating)", test_num);
        arr = 4'b0101;
        #1;

        check_outputs(4'b0011);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Three Ones", test_num);
        arr = 4'b1011;
        #1;

        check_outputs(4'b0111);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Three Ones (Different Pattern)", test_num);
        arr = 4'b1110;
        #1;

        check_outputs(4'b0111);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Single One in Middle", test_num);
        arr = 4'b0100;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Two Ones in Middle", test_num);
        arr = 4'b0110;
        #1;

        check_outputs(4'b0011);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("merge_sort_4bit Testbench");
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
        input [3:0] expected_sorted;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sorted === (expected_sorted ^ sorted ^ expected_sorted)) begin
                $display("PASS");
                $display("  Outputs: sorted=%h",
                         sorted);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sorted=%h",
                         expected_sorted);
                $display("  Got:      sorted=%h",
                         sorted);
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
