`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] addr;
    wire [3:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .dout(dout)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Testing addr = 0x00 (Expect 0xE)", test_num);
        addr = 6'h00;
        #1;

        check_outputs(4'hE);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Testing addr = 0x01 (Expect 0x4)", test_num);
        addr = 6'h01;
        #1;

        check_outputs(4'h4);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Testing addr = 0x07 (Expect 0x8)", test_num);
        addr = 6'h07;
        #1;

        check_outputs(4'h8);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Testing addr = 0x0F (Expect 0x7)", test_num);
        addr = 6'h0F;
        #1;

        check_outputs(4'h7);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Testing addr = 0x10 (Expect Default 0x0)", test_num);
        addr = 6'h10;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Testing addr = 0x3F (Expect Default 0x0)", test_num);
        addr = 6'h3F;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Testing addr = 0x2A (Expect Default 0x0)", test_num);
        addr = 6'h2A;
        #1;

        check_outputs(4'h0);
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
