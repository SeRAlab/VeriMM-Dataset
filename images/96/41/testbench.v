`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg data;
    reg [1:0] select;
    wire ch1;
    wire ch2;
    wire ch3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data(data),
        .select(select),
        .ch1(ch1),
        .ch2(ch2),
        .ch3(ch3)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: select=00, data=0", test_num);
        data = 0; select = 2'b00;
        #1;

        check_outputs(1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: select=00, data=1", test_num);
        data = 1; select = 2'b00;
        #1;

        check_outputs(1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: select=01, data=0", test_num);
        data = 0; select = 2'b01;
        #1;

        check_outputs(1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: select=01, data=1", test_num);
        data = 1; select = 2'b01;
        #1;

        check_outputs(1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: select=10, data=0", test_num);
        data = 0; select = 2'b10;
        #1;

        check_outputs(1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: select=10, data=1", test_num);
        data = 1; select = 2'b10;
        #1;

        check_outputs(1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: select=11 (default), data=0", test_num);
        data = 0; select = 2'b11;
        #1;

        check_outputs(1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %03d: select=11 (default), data=1", test_num);
        data = 1; select = 2'b11;
        #1;

        check_outputs(1'b0, 1'b1, 1'b0);
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
        input expected_ch1;
        input expected_ch2;
        input expected_ch3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ch1 === (expected_ch1 ^ ch1 ^ expected_ch1) &&
                expected_ch2 === (expected_ch2 ^ ch2 ^ expected_ch2) &&
                expected_ch3 === (expected_ch3 ^ ch3 ^ expected_ch3)) begin
                $display("PASS");
                $display("  Outputs: ch1=%b, ch2=%b, ch3=%b",
                         ch1, ch2, ch3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ch1=%b, ch2=%b, ch3=%b",
                         expected_ch1, expected_ch2, expected_ch3);
                $display("  Got:      ch1=%b, ch2=%b, ch3=%b",
                         ch1, ch2, ch3);
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
