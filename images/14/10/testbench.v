`timescale 1ns/1ps

module temperature_comparator_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] temp_input;
    reg [4:0] threshold;
    wire exceed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    temperature_comparator dut (
        .temp_input(temp_input),
        .threshold(threshold),
        .exceed(exceed)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All zeros (temp=0, thresh=0)", test_num);
            temp_input = 5'd0;
            threshold = 5'd0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input zero, threshold max (temp=0, thresh=31)", test_num);
            temp_input = 5'd0;
            threshold = 5'd31;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input max, threshold zero (temp=31, thresh=0)", test_num);
            temp_input = 5'd31;
            threshold = 5'd0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Both max (temp=31, thresh=31)", test_num);
            temp_input = 5'd31;
            threshold = 5'd31;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Midpoint equality (temp=15, thresh=15)", test_num);
            temp_input = 5'd15;
            threshold = 5'd15;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input just above threshold (temp=16, thresh=15)", test_num);
            temp_input = 5'd16;
            threshold = 5'd15;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input just below threshold (temp=14, thresh=15)", test_num);
            temp_input = 5'd14;
            threshold = 5'd15;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random typical high temp (temp=25, thresh=10)", test_num);
            temp_input = 5'd25;
            threshold = 5'd10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random typical low temp (temp=5, thresh=20)", test_num);
            temp_input = 5'd5;
            threshold = 5'd20;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary check near max (temp=31, thresh=30)", test_num);
            temp_input = 5'd31;
            threshold = 5'd30;
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
        $display("temperature_comparator Testbench");
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
        input expected_exceed;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_exceed === (expected_exceed ^ exceed ^ expected_exceed)) begin
                $display("PASS");
                $display("  Outputs: exceed=%b",
                         exceed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: exceed=%b",
                         expected_exceed);
                $display("  Got:      exceed=%b",
                         exceed);
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
