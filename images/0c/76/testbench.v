`timescale 1ns/1ps

module mac_address_filter_tb;

    // Testbench signals (combinational circuit)
    reg [47:0] mac_address;
    wire allowed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mac_address_filter dut (
        .mac_address(mac_address),
        .allowed(allowed)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Matching MAC Address (00:1A:2B:3C:4D:5E)", test_num);
        mac_address = 48'h001A2B3C4D5E;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Mismatch LSB (00:1A:2B:3C:4D:5F)", test_num);
        mac_address = 48'h001A2B3C4D5F;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Mismatch MSB (01:1A:2B:3C:4D:5E)", test_num);
        mac_address = 48'h011A2B3C4D5E;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All-zeros MAC", test_num);
        mac_address = 48'h000000000000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All-ones (Broadcast) MAC", test_num);
        mac_address = 48'hFFFFFFFFFFFF;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Inverted MAC bits", test_num);
        mac_address = ~48'h001A2B3C4D5E;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Middle byte mismatch (2B -> FF)", test_num);
        mac_address = 48'h001AFF3C4D5E;
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
        input expected_allowed;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_allowed === (expected_allowed ^ allowed ^ expected_allowed)) begin
                $display("PASS");
                $display("  Outputs: allowed=%b",
                         allowed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: allowed=%b",
                         expected_allowed);
                $display("  Got:      allowed=%b",
                         allowed);
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
