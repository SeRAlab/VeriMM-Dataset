`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [17:0] i_data;
    wire [24:0] o_data_25;
    wire [24:0] o_data_43;
    wire [24:0] o_data_57;
    wire [24:0] o_data_70;
    wire [24:0] o_data_80;
    wire [24:0] o_data_87;
    wire [24:0] o_data_9;
    wire [24:0] o_data_90;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_data(i_data),
        .o_data_25(o_data_25),
        .o_data_43(o_data_43),
        .o_data_57(o_data_57),
        .o_data_70(o_data_70),
        .o_data_80(o_data_80),
        .o_data_87(o_data_87),
        .o_data_9(o_data_9),
        .o_data_90(o_data_90)
    );
    task testcase001;

    begin
        test_num = 1;
        i_data = 18'd0;
        #1;

        check_outputs(25'd0, 25'd0, 25'd0, 25'd0, 25'd0, 25'd0, 25'd0, 25'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        i_data = 18'd1;

        #1;


        check_outputs(25'd25, 25'd43, 25'd57, 25'd70, 25'd80, 25'd87, 25'd9, 25'd90);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        i_data = 18'd100;
        #1;

        check_outputs(25'd2500, 25'd4300, 25'd5700, 25'd7000, 25'd8000, 25'd8700, 25'd900, 25'd9000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        i_data = 18'd2048;
        #1;

        check_outputs(25'd51200, 25'd88064, 25'd116736, 25'd143360, 25'd163840, 25'd178176, 25'd18432, 25'd184320);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        i_data = 18'h3FFFF;
        #1;

        check_outputs(25'd6553575, 25'd11272149, 25'd14942151, 25'd18350010, 25'd20971440, 25'd22806441, 25'd2359287, 25'd23592870);
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
        input [24:0] expected_o_data_25;
        input [24:0] expected_o_data_43;
        input [24:0] expected_o_data_57;
        input [24:0] expected_o_data_70;
        input [24:0] expected_o_data_80;
        input [24:0] expected_o_data_87;
        input [24:0] expected_o_data_9;
        input [24:0] expected_o_data_90;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_data_25 === (expected_o_data_25 ^ o_data_25 ^ expected_o_data_25) &&
                expected_o_data_43 === (expected_o_data_43 ^ o_data_43 ^ expected_o_data_43) &&
                expected_o_data_57 === (expected_o_data_57 ^ o_data_57 ^ expected_o_data_57) &&
                expected_o_data_70 === (expected_o_data_70 ^ o_data_70 ^ expected_o_data_70) &&
                expected_o_data_80 === (expected_o_data_80 ^ o_data_80 ^ expected_o_data_80) &&
                expected_o_data_87 === (expected_o_data_87 ^ o_data_87 ^ expected_o_data_87) &&
                expected_o_data_9 === (expected_o_data_9 ^ o_data_9 ^ expected_o_data_9) &&
                expected_o_data_90 === (expected_o_data_90 ^ o_data_90 ^ expected_o_data_90)) begin
                $display("PASS");
                $display("  Outputs: o_data_25=%h, o_data_43=%h, o_data_57=%h, o_data_70=%h, o_data_80=%h, o_data_87=%h, o_data_9=%h, o_data_90=%h",
                         o_data_25, o_data_43, o_data_57, o_data_70, o_data_80, o_data_87, o_data_9, o_data_90);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_data_25=%h, o_data_43=%h, o_data_57=%h, o_data_70=%h, o_data_80=%h, o_data_87=%h, o_data_9=%h, o_data_90=%h",
                         expected_o_data_25, expected_o_data_43, expected_o_data_57, expected_o_data_70, expected_o_data_80, expected_o_data_87, expected_o_data_9, expected_o_data_90);
                $display("  Got:      o_data_25=%h, o_data_43=%h, o_data_57=%h, o_data_70=%h, o_data_80=%h, o_data_87=%h, o_data_9=%h, o_data_90=%h",
                         o_data_25, o_data_43, o_data_57, o_data_70, o_data_80, o_data_87, o_data_9, o_data_90);
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
