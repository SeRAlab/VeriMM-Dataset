`timescale 1ns/1ps

module DAC_24bit_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] din;
    wire [23:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DAC_24bit dut (
        .din(din),
        .dout(dout)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Running Testcase %03d: All Zeros", test_num);
        din = 24'h000000;
        #1;

        check_outputs(24'h000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running Testcase %03d: All Ones", test_num);
        din = 24'hFFFFFF;
        #1;

        check_outputs(24'hFFFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Running Testcase %03d: Alternating Bits 0101", test_num);
        din = 24'h555555;
        #1;

        check_outputs(24'h555555);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running Testcase %03d: Alternating Bits 1010", test_num);
        din = 24'hAAAAAA;
        #1;

        check_outputs(24'hAAAAAA);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Running Testcase %03d: MSB only", test_num);
        din = 24'h800000;
        #1;

        check_outputs(24'h800000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Running Testcase %03d: LSB only", test_num);
        din = 24'h000001;
        #1;

        check_outputs(24'h000001);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Running Testcase %03d: Pattern 0x123456", test_num);
        din = 24'h123456;
        #1;

        check_outputs(24'h123456);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Running Testcase %03d: Pattern 0xABCDEF", test_num);
        din = 24'hABCDEF;
        #1;

        check_outputs(24'hABCDEF);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Running Testcase %03d: Alternating Nibbles F0F0", test_num);
        din = 24'hF0F0F0;
        #1;

        check_outputs(24'hF0F0F0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Running Testcase %03d: Max Value minus 1", test_num);
        din = 24'hFFFFFE;
        #1;

        check_outputs(24'hFFFFFE);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DAC_24bit Testbench");
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
        input [23:0] expected_dout;
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
