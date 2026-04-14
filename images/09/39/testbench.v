`timescale 1ns/1ps

module merge_sort_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data_in;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    merge_sort dut (
        .data_in(data_in),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = 1;
            data_in = 16'h1234;
            $display("Test %0d: Already sorted input [1, 2, 3, 4]", test_num);
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            data_in = 16'h4321;
            $display("Test %0d: Reverse sorted input [4, 3, 2, 1]", test_num);
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            data_in = 16'hF0F0;
            $display("Test %0d: Interleaved min/max [15, 0, 15, 0]", test_num);
            #1;

            check_outputs(16'h00FF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            data_in = 16'hA5C2;
            $display("Test %0d: Random distribution [10, 5, 12, 2]", test_num);
            #1;

            check_outputs(16'h25AC);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            data_in = 16'h7777;
            $display("Test %0d: All identical elements [7, 7, 7, 7]", test_num);
            #1;

            check_outputs(16'h7777);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            data_in = 16'h1838;
            $display("Test %0d: Duplicate elements [1, 8, 3, 8]", test_num);
            #1;

            check_outputs(16'h1388);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            data_in = 16'hB937;
            $display("Test %0d: Mixed values [11, 9, 3, 7]", test_num);
            #1;

            check_outputs(16'h379B);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            data_in = 16'h0001;
            $display("Test %0d: Single non-zero element at the end [0, 0, 0, 1]", test_num);
            #1;

            check_outputs(16'h0001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("merge_sort Testbench");
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
        input [15:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
