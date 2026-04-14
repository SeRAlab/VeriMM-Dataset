`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] din;
    reg [4:0] n;
    wire [31:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .din(din),
        .n(n),
        .dout(dout)
    );
    task testcase001;

    begin
        test_num = 1;
        din = 32'hFFFFFFFF;
        n = -5'sd1;
        #1;

        check_outputs(32'h00000003);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        din = 32'hFFFFFFFF;
        n = 5'sd0;
        #1;

        check_outputs(32'h00000006);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        din = 32'h00000050;
        n = 5'sd4;
        #1;

        check_outputs(32'h00000040);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        din = 32'hFFFFFFFF;
        n = 5'sd14;
        #1;

        check_outputs(32'h00018000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        din = 32'hAAAAAAAA;
        n = 5'sd15;

        #1;


        check_outputs(32'h00020000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        din = 32'hFFFFFFFF;
        n = -5'sd10;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        din = 32'h00000C00;
        n = 5'sd9;
        #1;

        check_outputs(32'h00000C00);
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
        input [31:0] expected_dout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
