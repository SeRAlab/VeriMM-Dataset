`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] mod0;
    wire [6:0] led;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .mod0(mod0),
        .led(led)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input mod0 = 0", test_num);
        mod0 = 4'd0;
        #1;

        check_outputs(7'b0111111);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input mod0 = 1", test_num);
        mod0 = 4'd1;
        #1;

        check_outputs(7'b0000110);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input mod0 = 2", test_num);
        mod0 = 4'd2;
        #1;

        check_outputs(7'b1011011);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input mod0 = 3", test_num);
        mod0 = 4'd3;
        #1;

        check_outputs(7'b1001111);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input mod0 = 4", test_num);
        mod0 = 4'd4;
        #1;

        check_outputs(7'b1100110);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input mod0 = 5", test_num);
        mod0 = 4'd5;
        #1;

        check_outputs(7'b1101101);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input mod0 = 6", test_num);
        mod0 = 4'd6;
        #1;

        check_outputs(7'b1111101);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input mod0 = 7", test_num);
        mod0 = 4'd7;
        #1;

        check_outputs(7'b0000111);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input mod0 = 8", test_num);
        mod0 = 4'd8;
        #1;

        check_outputs(7'b1111111);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input mod0 = 9", test_num);
        mod0 = 4'd9;
        #1;

        check_outputs(7'b1101111);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input mod0 = 10 (Invalid)", test_num);
        mod0 = 4'd10;
        #1;

        check_outputs(7'b0000000);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input mod0 = 15 (Invalid)", test_num);
        mod0 = 4'd15;
        #1;

        check_outputs(7'b0000000);
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
        input [6:0] expected_led;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_led === (expected_led ^ led ^ expected_led)) begin
                $display("PASS");
                $display("  Outputs: led=%h",
                         led);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: led=%h",
                         expected_led);
                $display("  Got:      led=%h",
                         led);
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
