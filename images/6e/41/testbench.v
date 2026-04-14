`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [14:0] din;
    wire [3:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .din(din),
        .dout(dout)
    );
    task testcase001;

    begin
        test_num = 1;
        din = 15'b0;
        #10;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        din = 15'h0001;
        #10;
        #1;

        check_outputs(4'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        din = 15'h4000;
        #10;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        din = 15'h0080;
        #10;
        #1;

        check_outputs(4'd8);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        din = 15'h4001;
        #10;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        din = 15'h0003;
        #10;
        #1;

        check_outputs(4'd2);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        din = 15'h0C00;
        #10;
        #1;

        check_outputs(4'd12);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        din = 15'h7FFF;
        #10;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        din = 15'h2AAA;
        #10;
        #1;

        check_outputs(4'd14);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        din = 15'h0010;
        #10;
        #1;

        check_outputs(4'd5);
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
        input [3:0] expected_dout;
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
