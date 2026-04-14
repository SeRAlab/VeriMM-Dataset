`timescale 1ns/1ps

module mac_address_filter_tb;

    // Testbench signals (combinational circuit)
    reg [47:0] allowed_mac_1;
    reg [47:0] allowed_mac_2;
    reg [47:0] allowed_mac_3;
    reg [47:0] received_mac;
    wire is_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mac_address_filter dut (
        .allowed_mac_1(allowed_mac_1),
        .allowed_mac_2(allowed_mac_2),
        .allowed_mac_3(allowed_mac_3),
        .received_mac(received_mac),
        .is_valid(is_valid)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Match with allowed_mac_1", test_num);
            allowed_mac_1 = 48'h001122334455;
            allowed_mac_2 = 48'hAABBCCDDEEFF;
            allowed_mac_3 = 48'h123456789ABC;
            received_mac  = 48'h001122334455;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Match with allowed_mac_2", test_num);
            allowed_mac_1 = 48'h001122334455;
            allowed_mac_2 = 48'hAABBCCDDEEFF;
            allowed_mac_3 = 48'h123456789ABC;
            received_mac  = 48'hAABBCCDDEEFF;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Match with allowed_mac_3", test_num);
            allowed_mac_1 = 48'h001122334455;
            allowed_mac_2 = 48'hAABBCCDDEEFF;
            allowed_mac_3 = 48'h123456789ABC;
            received_mac  = 48'h123456789ABC;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: No match (Valid but not in list)", test_num);
            allowed_mac_1 = 48'h001122334455;
            allowed_mac_2 = 48'hAABBCCDDEEFF;
            allowed_mac_3 = 48'h123456789ABC;
            received_mac  = 48'hDEADBEEFCAFE;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Broadcast address (Not in list)", test_num);
            allowed_mac_1 = 48'h001122334455;
            allowed_mac_2 = 48'hAABBCCDDEEFF;
            allowed_mac_3 = 48'h123456789ABC;
            received_mac  = 48'hFFFFFFFFFFFF;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All-zero addresses", test_num);
            allowed_mac_1 = 48'h0;
            allowed_mac_2 = 48'h0;
            allowed_mac_3 = 48'h0;
            received_mac  = 48'h0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Partial match check (off by 1 bit)", test_num);
            allowed_mac_1 = 48'h001122334455;
            allowed_mac_2 = 48'hAABBCCDDEEFF;
            allowed_mac_3 = 48'h123456789ABC;
            received_mac  = 48'h001122334454;
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
        input expected_is_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_is_valid === (expected_is_valid ^ is_valid ^ expected_is_valid)) begin
                $display("PASS");
                $display("  Outputs: is_valid=%b",
                         is_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: is_valid=%b",
                         expected_is_valid);
                $display("  Got:      is_valid=%b",
                         is_valid);
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
