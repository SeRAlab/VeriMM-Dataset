`timescale 1ns/1ps

module mac_filter_tb;

    // Testbench signals (combinational circuit)
    reg [47:0] mac_filter;
    reg [47:0] mac_in;
    wire match;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mac_filter dut (
        .mac_filter(mac_filter),
        .mac_in(mac_in),
        .match(match)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Exact Match (Specific Address)", test_num);
            mac_filter = 48'hA1B2C3D4E5F6;
            mac_in     = 48'hA1B2C3D4E5F6;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mismatch (LSB different)", test_num);
            mac_filter = 48'hA1B2C3D4E5F6;
            mac_in     = 48'hA1B2C3D4E5F7;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mismatch (MSB different)", test_num);
            mac_filter = 48'hA1B2C3D4E5F6;
            mac_in     = 48'hB1B2C3D4E5F6;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Exact Match (All Ones/Broadcast)", test_num);
            mac_filter = 48'hFFFFFFFFFFFF;
            mac_in     = 48'hFFFFFFFFFFFF;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Exact Match (All Zeros)", test_num);
            mac_filter = 48'h000000000000;
            mac_in     = 48'h000000000000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mismatch (Middle byte)", test_num);
            mac_filter = 48'h112233445566;
            mac_in     = 48'h1122AA445566;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mismatch (Filter Zeros vs Input One)", test_num);
            mac_filter = 48'h000000000000;
            mac_in     = 48'h000000000001;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternate Bit Pattern Match", test_num);
            mac_filter = 48'hAAAAAAAAAAAAAAAA;
            mac_in     = 48'hAAAAAAAAAAAAAAAA;
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mac_filter Testbench");
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
