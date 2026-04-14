`timescale 1ns/1ps

module mac_address_filter_tb;

    // Testbench signals (combinational circuit)
    reg [47:0] dest_mac;
    reg [47:0] filter_mac;
    wire match;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mac_address_filter dut (
        .dest_mac(dest_mac),
        .filter_mac(filter_mac),
        .match(match)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Perfect Match", test_num);
        dest_mac   = 48'hA1B2C3D4E5F6;
        filter_mac = 48'hA1B2C3D4E5F6;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Complete Mismatch", test_num);
        dest_mac   = 48'h001122334455;
        filter_mac = 48'hFFEEDDCCBBAA;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Single bit mismatch (LSB)", test_num);
        dest_mac   = 48'hFFFFFFFFFFFF;
        filter_mac = 48'hFFFFFFFFFFFE;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Single bit mismatch (MSB)", test_num);
        dest_mac   = 48'h7FFFFFFFFFFF;
        filter_mac = 48'hFFFFFFFFFFFF;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All Zeros Match", test_num);
        dest_mac   = 48'h000000000000;
        filter_mac = 48'h000000000000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Broadcast Address Match", test_num);
        dest_mac   = 48'hFFFFFFFFFFFF;
        filter_mac = 48'hFFFFFFFFFFFF;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Common Prefix Mismatch", test_num);
        dest_mac   = 48'h0010A5123456;
        filter_mac = 48'h0010A5999999;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Common Suffix Mismatch", test_num);
        dest_mac   = 48'h111111D4E5F6;
        filter_mac = 48'hA1B2C3D4E5F6;
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
