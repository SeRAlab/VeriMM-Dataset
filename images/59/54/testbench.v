`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [25:0] Data_Dec_i;
    wire [4:0] Data_Bin_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Data_Dec_i(Data_Dec_i),
        .Data_Bin_o(Data_Bin_o)
    );
    task testcase001;

    begin
        test_num = 1;
        Data_Dec_i = 26'h3FFFFFF;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        Data_Dec_i = 26'h3FFFFFE;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        Data_Dec_i = 26'h3FFFFFD;
        #1;

        check_outputs(5'd1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        Data_Dec_i = 26'h3FFFFFB;
        #1;

        check_outputs(5'd2);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        Data_Dec_i = 26'h3FFDFFF;
        #1;

        check_outputs(5'd13);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        Data_Dec_i = 26'h1FFFFFF;
        #1;

        check_outputs(5'd25);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        Data_Dec_i = ~(26'h0008020);
        #1;

        check_outputs(5'd5);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        Data_Dec_i = 26'h2FFFFFF;
        #1;

        check_outputs(5'd24);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        Data_Dec_i = 26'h0000000;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        Data_Dec_i = ~(26'h0700000);
        #1;

        check_outputs(5'd20);
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
        input [4:0] expected_Data_Bin_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Data_Bin_o === (expected_Data_Bin_o ^ Data_Bin_o ^ expected_Data_Bin_o)) begin
                $display("PASS");
                $display("  Outputs: Data_Bin_o=%h",
                         Data_Bin_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Data_Bin_o=%h",
                         expected_Data_Bin_o);
                $display("  Got:      Data_Bin_o=%h",
                         Data_Bin_o);
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
