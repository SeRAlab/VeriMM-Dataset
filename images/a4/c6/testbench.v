`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] number;
    wire [6:0] segment;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .number(number),
        .segment(segment)
    );
    task testcase001;

    begin
        test_num = 1;
        number = 5'd0;
        $display("Test Case %0d: Input number = %0d (Hex 0)", test_num, number);
        #1;

        check_outputs(7'h3f);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        number = 5'd1;
        $display("Test Case %0d: Input number = %0d (Hex 1)", test_num, number);
        #1;

        check_outputs(7'h06);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        number = 5'd2;
        $display("Test Case %0d: Input number = %0d (Hex 2)", test_num, number);
        #1;

        check_outputs(7'h5b);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        number = 5'd3;
        $display("Test Case %0d: Input number = %0d (Hex 3)", test_num, number);
        #1;

        check_outputs(7'h4f);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        number = 5'd4;
        $display("Test Case %0d: Input number = %0d (Hex 4)", test_num, number);
        #1;

        check_outputs(7'h66);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        number = 5'd5;
        $display("Test Case %0d: Input number = %0d (Hex 5)", test_num, number);
        #1;

        check_outputs(7'h6d);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        number = 5'd6;
        $display("Test Case %0d: Input number = %0d (Hex 6)", test_num, number);
        #1;

        check_outputs(7'h7d);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        number = 5'd7;
        $display("Test Case %0d: Input number = %0d (Hex 7)", test_num, number);
        #1;

        check_outputs(7'h07);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        number = 5'd8;
        $display("Test Case %0d: Input number = %0d (Hex 8)", test_num, number);
        #1;

        check_outputs(7'h7f);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        number = 5'd9;
        $display("Test Case %0d: Input number = %0d (Hex 9)", test_num, number);
        #1;

        check_outputs(7'h6f);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        number = 5'd10;
        $display("Test Case %0d: Input number = %0d (Hex A)", test_num, number);
        #1;

        check_outputs(7'h77);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        number = 5'd11;
        $display("Test Case %0d: Input number = %0d (Hex B)", test_num, number);
        #1;

        check_outputs(7'h7c);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        number = 5'd12;
        $display("Test Case %0d: Input number = %0d (Hex C)", test_num, number);
        #1;

        check_outputs(7'h39);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        number = 5'd13;
        $display("Test Case %0d: Input number = %0d (Hex D)", test_num, number);
        #1;

        check_outputs(7'h5e);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        number = 5'd14;
        $display("Test Case %0d: Input number = %0d (Hex E)", test_num, number);
        #1;

        check_outputs(7'h79);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        number = 5'd15;
        $display("Test Case %0d: Input number = %0d (Hex F)", test_num, number);
        #1;

        check_outputs(7'h71);
    end
        endtask

    task testcase017;

    begin
        test_num = 17;
        number = 5'd16;
        $display("Test Case %0d: Input number = %0d (Out of range)", test_num, number);
        #1;

        check_outputs(7'h00);
    end
        endtask

    task testcase018;

    begin
        test_num = 18;
        number = 5'd31;
        $display("Test Case %0d: Input number = %0d (Out of range boundary)", test_num, number);
        #1;

        check_outputs(7'h00);
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
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        testcase017();
        testcase018();
        
        
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
        input [6:0] expected_segment;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_segment === (expected_segment ^ segment ^ expected_segment)) begin
                $display("PASS");
                $display("  Outputs: segment=%h",
                         segment);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: segment=%h",
                         expected_segment);
                $display("  Got:      segment=%h",
                         segment);
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
