`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] idat;
    wire [63:0] odat;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .idat(idat),
        .odat(odat)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        idat = 64'h0000_0000_0000_0000;
        #1;

        check_outputs(ref_model(idat));
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        idat = 64'hFFFF_FFFF_FFFF_FFFF;
        #1;

        check_outputs(ref_model(idat));
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        idat = 64'hAAAA_AAAA_AAAA_AAAA;
        #1;

        check_outputs(ref_model(idat));
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        idat = 64'h5555_5555_5555_5555;
        #1;

        check_outputs(ref_model(idat));
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        idat = 64'h0000_0000_0000_0001;
        #1;

        check_outputs(ref_model(idat));
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        idat = 64'h8000_0000_0000_0000;
        #1;

        check_outputs(ref_model(idat));
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        idat = 64'hFFFF_FFFF_0000_0000;
        #1;

        check_outputs(ref_model(idat));
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        idat = 64'h0123_4567_89AB_CDEF;
        #1;

        check_outputs(ref_model(idat));
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        idat = 64'hFF00_FF00_FF00_FF00;
        #1;

        check_outputs(ref_model(idat));
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        idat = 64'hA5A5_5A5A_0F0F_F0F0;
        #1;

        check_outputs(ref_model(idat));
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
        input [63:0] expected_odat;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_odat === (expected_odat ^ odat ^ expected_odat)) begin
                $display("PASS");
                $display("  Outputs: odat=%h",
                         odat);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: odat=%h",
                         expected_odat);
                $display("  Got:      odat=%h",
                         odat);
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
