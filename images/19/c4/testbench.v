`timescale 1ns/1ps

module quick_sort_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data_in;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    quick_sort dut (
        .data_in(data_in),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Already sorted (small, large)", test_num);
        data_in = 16'h050A;
        #1;

        check_outputs(16'h050A);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Reverse order (large, small)", test_num);
        data_in = 16'h0A05;
        #1;

        check_outputs(16'h050A);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Equal values", test_num);
        data_in = 16'hFF_FF;
        #1;

        check_outputs(16'hFF_FF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Zeroes", test_num);
        data_in = 16'h00_00;
        #1;

        check_outputs(16'h00_00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Minimum and Maximum reversed", test_num);
        data_in = 16'hFF_00;
        #1;

        check_outputs(16'h00_FF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Minimum and Maximum already sorted", test_num);
        data_in = 16'h00_FF;
        #1;

        check_outputs(16'h00_FF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Values with same high nibble", test_num);
        data_in = 16'h12_11;
        #1;

        check_outputs(16'h11_12);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Values near the boundary", test_num);
        data_in = 16'h80_7F;
        #1;

        check_outputs(16'h7F_80);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: Random arbitrary values", test_num);
        data_in = 16'hA5_5A;
        #1;

        check_outputs(16'h5A_A5);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: One value is zero", test_num);
        data_in = 16'h42_00;
        #1;

        check_outputs(16'h00_42);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("quick_sort Testbench");
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
