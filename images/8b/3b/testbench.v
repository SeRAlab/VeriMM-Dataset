`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg data_0;
    reg data_1;
    reg data_2;
    reg data_3;
    reg data_4;
    reg data_5;
    reg data_6;
    reg data_7;
    wire [7:0] ccat_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_0(data_0),
        .data_1(data_1),
        .data_2(data_2),
        .data_3(data_3),
        .data_4(data_4),
        .data_5(data_5),
        .data_6(data_6),
        .data_7(data_7),
        .ccat_data(ccat_data)
    );
    task testcase001;

    begin
        test_num = 1;
        data_7=0; data_6=0; data_5=0; data_4=0; data_3=0; data_2=0; data_1=0; data_0=0;
        #1;

        check_outputs(8'b00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        data_7=1; data_6=1; data_5=1; data_4=1; data_3=1; data_2=1; data_1=1; data_0=1;
        #1;

        check_outputs(8'b11111111);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        data_7=0; data_6=0; data_5=0; data_4=0; data_3=0; data_2=0; data_1=0; data_0=1;
        #1;

        check_outputs(8'b00000001);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        data_7=1; data_6=0; data_5=0; data_4=0; data_3=0; data_2=0; data_1=0; data_0=0;
        #1;

        check_outputs(8'b10000000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        data_7=1; data_6=0; data_5=1; data_4=0; data_3=1; data_2=0; data_1=1; data_0=0;
        #1;

        check_outputs(8'b10101010);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        data_7=0; data_6=1; data_5=0; data_4=1; data_3=0; data_2=1; data_1=0; data_0=1;
        #1;

        check_outputs(8'b01010101);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        data_7=1; data_6=1; data_5=1; data_4=1; data_3=0; data_2=0; data_1=0; data_0=0;
        #1;

        check_outputs(8'b11110000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        data_7=1; data_6=0; data_5=0; data_4=1; data_3=1; data_2=1; data_1=0; data_0=1;
        #1;

        check_outputs(8'b10011101);
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
        input [7:0] expected_ccat_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ccat_data === (expected_ccat_data ^ ccat_data ^ expected_ccat_data)) begin
                $display("PASS");
                $display("  Outputs: ccat_data=%h",
                         ccat_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ccat_data=%h",
                         expected_ccat_data);
                $display("  Got:      ccat_data=%h",
                         ccat_data);
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
