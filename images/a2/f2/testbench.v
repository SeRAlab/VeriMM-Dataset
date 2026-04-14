`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] B;
    reg [1:0] ctrl;
    reg enable;
    wire [31:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .B(B),
        .ctrl(ctrl),
        .enable(enable),
        .dout(dout)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Enable signal check (Enable=0)", test_num);
        enable = 0;
        B = 32'hFFFFFFFF;
        ctrl = 2'b11;


        #1;



        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Shift amount 0 (ctrl=00)", test_num);
        enable = 1;
        B = 32'hA5A5A5A5;
        ctrl = 2'b00;

        #1;


        check_outputs(32'hA5A5A5A5);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Shift amount 1 (ctrl=01)", test_num);
        enable = 1;
        B = 32'h55555555;
        ctrl = 2'b01;

        #1;


        check_outputs(32'hAAAAAAAA);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Shift amount 2 (ctrl=10)", test_num);
        enable = 1;
        B = 32'h11111111;
        ctrl = 2'b10;

        #1;


        check_outputs(32'h44444444);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Shift amount 3 (ctrl=11)", test_num);
        enable = 1;
        B = 32'h0F0F0F0F;
        ctrl = 2'b11;

        #1;


        check_outputs(32'h78787878);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Edge case - shifting bits out (ctrl=11)", test_num);
        enable = 1;
        B = 32'hE0000000;
        ctrl = 2'b11;

        #1;


        check_outputs(32'h00000000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Alternating bit pattern (ctrl=10)", test_num);
        enable = 1;
        B = 32'h33333333;
        ctrl = 2'b10;

        #1;


        check_outputs(32'hCCCCCCCC);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Zero input shift", test_num);
        enable = 1;
        B = 32'h00000000;
        ctrl = 2'b11;
        #1;

        check_outputs(32'h00000000);
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
