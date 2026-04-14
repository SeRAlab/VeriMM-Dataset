`timescale 1ns/1ps

module mac_address_filter_tb;

    // Testbench signals (combinational circuit)
    reg [47:0] mac_address;
    wire is_allowed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mac_address_filter dut (
        .mac_address(mac_address),
        .is_allowed(is_allowed)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Matching MAC Address (AA:BB:CC:DD:EE:FF)", test_num);
        mac_address = 48'hAABBCCDDEEFF;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: All Zeros MAC Address", test_num);
        mac_address = 48'h000000000000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Broadcast MAC Address (FF:FF:FF:FF:FF:FF)", test_num);
        mac_address = 48'hFFFFFFFFFFFF;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Single bit difference in most significant byte", test_num);
        mac_address = 48'hABB BCCDDEEFF;
        mac_address = 48'hA9BBCCDDEEFF;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Single bit difference in least significant byte", test_num);
        mac_address = 48'hAABBCCDDEEFE;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Middle byte mismatch", test_num);
        mac_address = 48'hAABB00DDEEFF;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Swapped nibbles in a byte", test_num);
        mac_address = 48'hBBAACCDDEEFF;
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
        input expected_is_allowed;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_is_allowed === (expected_is_allowed ^ is_allowed ^ expected_is_allowed)) begin
                $display("PASS");
                $display("  Outputs: is_allowed=%b",
                         is_allowed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: is_allowed=%b",
                         expected_is_allowed);
                $display("  Got:      is_allowed=%b",
                         is_allowed);
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
