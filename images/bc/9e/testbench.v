`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] clkin;
    reg [1:0] phasectrlin;
    reg phaseinvertctrl;
    reg powerdown;
    wire clkout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clkin(clkin),
        .phasectrlin(phasectrlin),
        .phaseinvertctrl(phaseinvertctrl),
        .powerdown(powerdown),
        .clkout(clkout)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select Phase 0, No Invert", test_num);
        powerdown = 1'b0;
        phaseinvertctrl = 1'b0;
        clkin = 4'b1110;
        phasectrlin = 2'b00;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select Phase 1, No Invert", test_num);
        powerdown = 1'b0;
        phaseinvertctrl = 1'b0;
        clkin = 4'b0010;
        phasectrlin = 2'b01;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select Phase 2, No Invert", test_num);
        powerdown = 1'b0;
        phaseinvertctrl = 1'b0;
        clkin = 4'b0100;
        phasectrlin = 2'b10;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select Phase 3, No Invert", test_num);
        powerdown = 1'b0;
        phaseinvertctrl = 1'b0;
        clkin = 4'b0111;
        phasectrlin = 2'b11;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select Phase 0, Invert 0 to 1", test_num);
        powerdown = 1'b0;
        phaseinvertctrl = 1'b1;
        clkin = 4'b1110;
        phasectrlin = 2'b00;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select Phase 1, Invert 1 to 0", test_num);
        powerdown = 1'b0;
        phaseinvertctrl = 1'b1;
        clkin = 4'b0010;
        phasectrlin = 2'b01;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Power Down Mode (Output should be 0)", test_num);
        powerdown = 1'b1;
        phaseinvertctrl = 1'b0;
        clkin = 4'b1111;
        phasectrlin = 2'b00;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Power Down Priority over Invert", test_num);
        powerdown = 1'b1;
        phaseinvertctrl = 1'b1;
        clkin = 4'b0000;
        phasectrlin = 2'b00;
        #10;
        #1;

        check_outputs(1'b0);
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
        input expected_clkout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_clkout === (expected_clkout ^ clkout ^ expected_clkout)) begin
                $display("PASS");
                $display("  Outputs: clkout=%b",
                         clkout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clkout=%b",
                         expected_clkout);
                $display("  Got:      clkout=%b",
                         clkout);
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
