`timescale 1ns/1ps

module comparator_32bit_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    wire [1:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    comparator_32bit dut (
        .a(a),
        .b(b),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Equality - Zero", test_num);
            a = 32'h0;
            b = 32'h0;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Equality - Maximum Unsigned", test_num);
            a = 32'hFFFFFFFF;
            b = 32'hFFFFFFFF;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Greater Than - Small values", test_num);
            a = 32'd100;
            b = 32'd50;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Less Than - Small values", test_num);
            a = 32'd50;
            b = 32'd100;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Greater Than - MSB set vs not set", test_num);
            a = 32'h80000000;
            b = 32'h7FFFFFFF;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Less Than - MSB not set vs set", test_num);
            a = 32'h7FFFFFFF;
            b = 32'h80000000;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Greater Than - Max vs Min", test_num);
            a = 32'hFFFFFFFF;
            b = 32'h00000000;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Less Than - Min vs Max", test_num);
            a = 32'h00000000;
            b = 32'hFFFFFFFF;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Equality - Middle range", test_num);
            a = 32'h12345678;
            b = 32'h12345678;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Greater Than - Difference in LSB only", test_num);
            a = 32'hABCDEF02;
            b = 32'hABCDEF01;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("Testcase %0d: Less Than - Difference in LSB only", test_num);
            a = 32'hABCDEF01;
            b = 32'hABCDEF02;
            #1;

            check_outputs(2'b11);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("comparator_32bit Testbench");
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
        input [1:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
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
