`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data;
    reg direction;
    reg [4:0] distance;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data(data),
        .direction(direction),
        .distance(distance),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Logical Left Shift - Basic", test_num);
            data = 32'h0000_0001;
            direction = 1'b0;
            distance = 5'd4;
            #1;

            check_outputs(32'h0000_0010);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Logical Left Shift - Fill zeros", test_num);
            data = 32'hFFFF_FFFF;
            direction = 1'b0;
            distance = 5'd8;
            #1;

            check_outputs(32'hFFFF_FF00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Logical Left Shift - Shift out MSB", test_num);
            data = 32'h8000_0000;
            direction = 1'b0;
            distance = 5'd1;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Arithmetic Right Shift - Positive", test_num);
            data = 32'h7000_0000;
            direction = 1'b1;
            distance = 5'd4;
            #1;

            check_outputs(32'h0700_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Arithmetic Right Shift - Sign Extension", test_num);
            data = 32'h8000_0000;
            direction = 1'b1;
            distance = 5'd1;
            #1;

            check_outputs(32'hC000_0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Arithmetic Right Shift - Large shift sign fill", test_num);
            data = 32'hF000_0000;
            direction = 1'b1;
            distance = 5'd28;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Logical Left Shift - Zero distance", test_num);
            data = 32'hDEAD_BEEF;
            direction = 1'b0;
            distance = 5'd0;
            #1;

            check_outputs(32'hDEAD_BEEF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Arithmetic Right Shift - Zero distance", test_num);
            data = 32'hA5A5_A5A5;
            direction = 1'b1;
            distance = 5'd0;
            #1;

            check_outputs(32'hA5A5_A5A5);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Logical Left Shift - Max distance (31)", test_num);
            data = 32'h0000_0001;
            direction = 1'b0;
            distance = 5'd31;
            #1;

            check_outputs(32'h8000_0000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Arithmetic Right Shift - Max distance negative", test_num);
            data = 32'h8000_0000;
            direction = 1'b1;
            distance = 5'd31;
            #1;

            check_outputs(32'hFFFF_FFFF);
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
        input [31:0] expected_result;
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
