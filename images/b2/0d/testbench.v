`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] d;
    reg [7:0] d_0;
    reg [7:0] d_1;
    reg [7:0] d_2;
    reg [7:0] d_3;
    wire [7:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .d(d),
        .d_0(d_0),
        .d_1(d_1),
        .d_2(d_2),
        .d_3(d_3),
        .dout(dout)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Select d_0", test_num);
        d_0 = 8'hAA;
        d_1 = 8'hBB;
        d_2 = 8'hCC;
        d_3 = 8'hDD;
        d = 2'b00;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Select d_1", test_num);
        d_0 = 8'hAA;
        d_1 = 8'hBB;
        d_2 = 8'hCC;
        d_3 = 8'hDD;
        d = 2'b01;
        #1;

        check_outputs(8'hBB);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Select d_2", test_num);
        d_0 = 8'hAA;
        d_1 = 8'hBB;
        d_2 = 8'hCC;
        d_3 = 8'hDD;
        d = 2'b10;
        #1;

        check_outputs(8'hCC);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Select d_3", test_num);
        d_0 = 8'hAA;
        d_1 = 8'hBB;
        d_2 = 8'hCC;
        d_3 = 8'hDD;
        d = 2'b11;
        #1;

        check_outputs(8'hDD);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Boundary Values All Zeros", test_num);
        d_0 = 8'h00; d_1 = 8'h00; d_2 = 8'h00; d_3 = 8'h00;
        d = 2'b00;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Boundary Values All Ones", test_num);
        d_0 = 8'hFF; d_1 = 8'hFF; d_2 = 8'hFF; d_3 = 8'hFF;
        d = 2'b11;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Walking Bit Pattern", test_num);
        d_0 = 8'h01; d_1 = 8'h02; d_2 = 8'h04; d_3 = 8'h08;
        d = 2'b10;
        #1;

        check_outputs(8'h04);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Alternating Bits Select d_1", test_num);
        d_0 = 8'h55; d_1 = 8'hAA; d_2 = 8'h55; d_3 = 8'hAA;
        d = 2'b01;
        #1;

        check_outputs(8'hAA);
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
        input [7:0] expected_dout;
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
