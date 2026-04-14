`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [25:0] Data_i;
    reg select_i;
    wire [25:0] Data_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Data_i(Data_i),
        .select_i(select_i),
        .Data_o(Data_o)
    );
    task testcase001;

    begin
        test_num = 1;
        Data_i = 26'h0000000;
        select_i = 1'b0;
        #1;

        check_outputs(26'h0000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        Data_i = 26'h3FFFFFF;
        select_i = 1'b0;
        #1;

        check_outputs(26'h3FFFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        Data_i = 26'h1234567;
        select_i = 1'b0;
        #1;

        check_outputs(26'h1234567);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        Data_i = 26'h0000000;
        select_i = 1'b1;
        #1;

        check_outputs(26'h0000000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        Data_i = 26'h3FFFFFF;
        select_i = 1'b1;
        #1;

        check_outputs(26'h3FFFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        Data_i = 26'h0000001;
        select_i = 1'b1;
        #1;

        check_outputs(26'h0002000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        Data_i = 26'h0002000;
        select_i = 1'b1;
        #1;

        check_outputs(26'h0000001);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        Data_i = 26'h2000000;
        select_i = 1'b1;
        #1;

        check_outputs(26'h0001000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        Data_i = 26'h0001000;
        select_i = 1'b1;
        #1;

        check_outputs(26'h2000000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        Data_i = 26'h1555555;
        select_i = 1'b1;
        #1;

        check_outputs(26'h2AAAAAA);
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
        input [25:0] expected_Data_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Data_o === (expected_Data_o ^ Data_o ^ expected_Data_o)) begin
                $display("PASS");
                $display("  Outputs: Data_o=%h",
                         Data_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Data_o=%h",
                         expected_Data_o);
                $display("  Got:      Data_o=%h",
                         Data_o);
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
