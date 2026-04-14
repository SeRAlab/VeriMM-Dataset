`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] crc;
    reg [7:0] x;
    wire [15:0] crc_new;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .crc(crc),
        .x(x),
        .crc_new(crc_new)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: All zeros input", test_num);
        crc = 16'h0000;
        x = 8'h00;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Single bit in data (x=01)", test_num);
        crc = 16'h0000;
        x = 8'h01;
        #1;

        check_outputs(16'h1115);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Single bit in data (x=02)", test_num);
        crc = 16'h0000;
        x = 8'h02;
        #1;

        check_outputs(16'h222a);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Full byte data (x=ff)", test_num);
        crc = 16'h0000;
        x = 8'hff;
        #1;

        check_outputs(16'h555f);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Full CRC state, zero data", test_num);
        crc = 16'hffff;
        x = 8'h00;
        #1;

        check_outputs(16'heeee);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Full CRC state, full byte data", test_num);
        crc = 16'hffff;
        x = 8'hff;
        #1;

        check_outputs(16'hff00);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Arbitrary mixed values 1", test_num);
        crc = 16'h1234;
        x = 8'h56;
        #1;

        check_outputs(16'hc986);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %03d: Arbitrary mixed values 2", test_num);
        crc = 16'habcd;
        x = 8'hef;
        #1;

        check_outputs(16'h3312);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %03d: Power of two data bit 7", test_num);
        crc = 16'h0000;
        x = 8'h80;
        #1;

        check_outputs(16'h8881);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %03d: Alternating bits", test_num);
        crc = 16'haaaa;
        x = 8'h55;
        #1;

        check_outputs(16'h0000);
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
        input [15:0] expected_crc_new;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_crc_new === (expected_crc_new ^ crc_new ^ expected_crc_new)) begin
                $display("PASS");
                $display("  Outputs: crc_new=%h",
                         crc_new);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: crc_new=%h",
                         expected_crc_new);
                $display("  Got:      crc_new=%h",
                         crc_new);
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
