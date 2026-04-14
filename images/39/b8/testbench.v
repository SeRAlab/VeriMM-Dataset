`timescale 1ns/1ps

module comparator_64bit_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] A;
    reg [63:0] B;
    wire equal_to;
    wire greater_than;
    wire less_than;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    comparator_64bit dut (
        .A(A),
        .B(B),
        .equal_to(equal_to),
        .greater_than(greater_than),
        .less_than(less_than)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Equal zeros", test_num);
            A = 64'h0;
            B = 64'h0;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Equal maximum values", test_num);
            A = 64'hFFFFFFFFFFFFFFFF;
            B = 64'hFFFFFFFFFFFFFFFF;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A > B (LSB difference)", test_num);
            A = 64'h1;
            B = 64'h0;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A < B (LSB difference)", test_num);
            A = 64'h0;
            B = 64'h1;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A > B (MSB difference)", test_num);
            A = 64'h8000000000000000;
            B = 64'h7FFFFFFFFFFFFFFF;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A < B (MSB difference)", test_num);
            A = 64'h7FFFFFFFFFFFFFFF;
            B = 64'h8000000000000000;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Equal mid-range pattern", test_num);
            A = 64'hAAAAAAAAAAAAAAAA;
            B = 64'hAAAAAAAAAAAAAAAA;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A > B (Middle bit difference)", test_num);
            A = 64'h00000000F0000000;
            B = 64'h00000000E0000000;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A < B (Middle bit difference)", test_num);
            A = 64'h00000000E0000000;
            B = 64'h00000000F0000000;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Complex bit pattern comparison", test_num);
            A = 64'hFEDCBA9876543210;
            B = 64'hFEDCBA9876543211;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("comparator_64bit Testbench");
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
        input expected_equal_to;
        input expected_greater_than;
        input expected_less_than;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_equal_to === (expected_equal_to ^ equal_to ^ expected_equal_to) &&
                expected_greater_than === (expected_greater_than ^ greater_than ^ expected_greater_than) &&
                expected_less_than === (expected_less_than ^ less_than ^ expected_less_than)) begin
                $display("PASS");
                $display("  Outputs: equal_to=%b, greater_than=%b, less_than=%b",
                         equal_to, greater_than, less_than);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: equal_to=%b, greater_than=%b, less_than=%b",
                         expected_equal_to, expected_greater_than, expected_less_than);
                $display("  Got:      equal_to=%b, greater_than=%b, less_than=%b",
                         equal_to, greater_than, less_than);
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
