`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] number;
    wire [6:0] cathode;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .number(number),
        .cathode(cathode)
    );
    task testcase001;

    begin
        test_num = 1;
        number = 4'd0;
        $display("Test Case %0d: Input Number = %d", test_num, number);

        #1;


        check_outputs(7'b0111111);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        number = 4'd1;
        $display("Test Case %0d: Input Number = %d", test_num, number);

        #1;


        check_outputs(7'b0000110);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        number = 4'd2;
        $display("Test Case %0d: Input Number = %d", test_num, number);

        #1;


        check_outputs(7'b1011011);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        number = 4'd3;
        $display("Test Case %0d: Input Number = %d", test_num, number);

        #1;


        check_outputs(7'b1001111);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        number = 4'd4;
        $display("Test Case %0d: Input Number = %d", test_num, number);

        #1;


        check_outputs(7'b1100110);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        number = 4'd5;
        $display("Test Case %0d: Input Number = %d", test_num, number);

        #1;


        check_outputs(7'b1101101);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        number = 4'd6;
        $display("Test Case %0d: Input Number = %d", test_num, number);

        #1;


        check_outputs(7'b1111101);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        number = 4'd7;
        $display("Test Case %0d: Input Number = %d", test_num, number);

        #1;


        check_outputs(7'b0000111);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        number = 4'd8;
        $display("Test Case %0d: Input Number = %d", test_num, number);

        #1;


        check_outputs(7'b1111111);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        number = 4'd9;
        $display("Test Case %0d: Input Number = %d", test_num, number);

        #1;


        check_outputs(7'b1101111);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        number = 4'd10;
        $display("Test Case %0d: Input Number = %d (A)", test_num, number);

        #1;


        check_outputs(7'b1110111);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        number = 4'd11;
        $display("Test Case %0d: Input Number = %d (B)", test_num, number);

        #1;


        check_outputs(7'b1111100);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        number = 4'd12;
        $display("Test Case %0d: Input Number = %d (C)", test_num, number);

        #1;


        check_outputs(7'b0111001);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        number = 4'd13;
        $display("Test Case %0d: Input Number = %d (D)", test_num, number);

        #1;


        check_outputs(7'b1011110);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        number = 4'd14;
        $display("Test Case %0d: Input Number = %d (E)", test_num, number);

        #1;


        check_outputs(7'b1111001);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        number = 4'd15;
        $display("Test Case %0d: Input Number = %d (F)", test_num, number);

        #1;


        check_outputs(7'b1110001);
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
        input [6:0] expected_cathode;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cathode === (expected_cathode ^ cathode ^ expected_cathode)) begin
                $display("PASS");
                $display("  Outputs: cathode=%h",
                         cathode);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cathode=%h",
                         expected_cathode);
                $display("  Got:      cathode=%h",
                         cathode);
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
