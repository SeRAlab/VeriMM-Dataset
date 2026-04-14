`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in0;
    reg [3:0] in1;
    wire <;
    wire =;
    wire >;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in0(in0),
        .in1(in1),
        .<(<),
        .=(=),
        .>(>)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Equal zeros (0 == 0)", test_num);
            in0 = 4'd0;
            in1 = 4'd0;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Equal max values (15 == 15)", test_num);
            in0 = 4'd15;
            in1 = 4'd15;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: in0 greater than in1 (1 > 0)", test_num);
            in0 = 4'd1;
            in1 = 4'd0;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: in0 less than in1 (0 < 1)", test_num);
            in0 = 4'd0;
            in1 = 4'd1;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: in0 much greater than in1 (15 > 1)", test_num);
            in0 = 4'd15;
            in1 = 4'd1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: in0 much less than in1 (2 < 14)", test_num);
            in0 = 4'd2;
            in1 = 4'd14;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mid-range equality (7 == 7)", test_num);
            in0 = 4'd7;
            in1 = 4'd7;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary check (8 > 7)", test_num);
            in0 = 4'd8;
            in1 = 4'd7;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary check (7 < 8)", test_num);
            in0 = 4'd7;
            in1 = 4'd8;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pattern check (10 > 5)", test_num);
            in0 = 4'b1010;
            in1 = 4'b0101;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input expected_<;
        input expected_=;
        input expected_>;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_< === (expected_< ^ < ^ expected_<) &&
                expected_= === (expected_= ^ = ^ expected_=) &&
                expected_> === (expected_> ^ > ^ expected_>)) begin
                $display("PASS");
                $display("  Outputs: <=%b, ==%b, >=%b",
                         <, =, >);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: <=%b, ==%b, >=%b",
                         expected_<, expected_=, expected_>);
                $display("  Got:      <=%b, ==%b, >=%b",
                         <, =, >);
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
