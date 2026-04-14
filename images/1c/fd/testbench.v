`timescale 1ns/1ps

module mac_address_filter_tb;

    // Testbench signals (combinational circuit)
    reg [47:0] eth_addr;
    reg [47:0] predefined_addr;
    wire match;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mac_address_filter dut (
        .eth_addr(eth_addr),
        .predefined_addr(predefined_addr),
        .match(match)
    );
    task testcase001;

        begin
            $display("Testcase 001: Exact Match");
            eth_addr = 48'hAABBCCDDEEFF;
            predefined_addr = 48'hAABBCCDDEEFF;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Complete Mismatch");
            eth_addr = 48'h112233445566;
            predefined_addr = 48'hFFEEDDCCBBAA;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Single Bit Mismatch (LSB)");
            eth_addr = 48'h000000000001;
            predefined_addr = 48'h000000000000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Single Bit Mismatch (MSB)");
            eth_addr = 48'h800000000000;
            predefined_addr = 48'h000000000000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: All Zeros Match");
            eth_addr = 48'h000000000000;
            predefined_addr = 48'h000000000000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: All Ones Match");
            eth_addr = 48'hFFFFFFFFFFFF;
            predefined_addr = 48'hFFFFFFFFFFFF;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Common OUI Match, NIC ID Mismatch");
            eth_addr = 48'h0010A4778899;
            predefined_addr = 48'h0010A4112233;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Broadcast Address vs Unicast Filter");
            eth_addr = 48'hFFFFFFFFFFFF;
            predefined_addr = 48'hDEADC0D3BEEF;
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
        $display("mac_address_filter Testbench");
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
        input expected_match;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_match === (expected_match ^ match ^ expected_match)) begin
                $display("PASS");
                $display("  Outputs: match=%b",
                         match);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: match=%b",
                         expected_match);
                $display("  Got:      match=%b",
                         match);
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
