`timescale 1ns/1ps

module NAT_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] external_ip;
    reg [31:0] internal_ip;
    reg operation_code;
    wire [31:0] translated_ip;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    NAT dut (
        .external_ip(external_ip),
        .internal_ip(internal_ip),
        .operation_code(operation_code),
        .translated_ip(translated_ip)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Basic Mapping (Internal to External)", test_num);
            internal_ip = 32'hC0A8010A;
            external_ip = 32'h08080808;
            operation_code = 1'b0;
            #1;

            check_outputs(32'h08080808);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Basic Unmapping (External to Internal)", test_num);
            internal_ip = 32'hC0A8010A;
            external_ip = 32'h08080808;
            operation_code = 1'b1;
            #1;

            check_outputs(32'hC0A8010A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Mapping with different Class A network", test_num);
            internal_ip = 32'h0A000005;
            external_ip = 32'hCB007105;
            operation_code = 1'b0;
            #1;

            check_outputs(32'hCB007105);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Unmapping with different Class A network", test_num);
            internal_ip = 32'h0A000005;
            external_ip = 32'hCB007105;
            operation_code = 1'b1;
            #1;

            check_outputs(32'h0A000005);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Edge case - All Zeros Mapping", test_num);
            internal_ip = 32'h00000000;
            external_ip = 32'hFFFFFFFF;
            operation_code = 1'b0;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Edge case - All Ones Unmapping", test_num);
            internal_ip = 32'hFFFFFFFF;
            external_ip = 32'h00000000;
            operation_code = 1'b1;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Random IP Mapping", test_num);
            internal_ip = 32'hAC100001;
            external_ip = 32'h42424242;
            operation_code = 1'b0;
            #1;

            check_outputs(32'h42424242);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Random IP Unmapping", test_num);
            internal_ip = 32'hAC100001;
            external_ip = 32'h42424242;
            operation_code = 1'b1;
            #1;

            check_outputs(32'hAC100001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("NAT Testbench");
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
        input [31:0] expected_translated_ip;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_translated_ip === (expected_translated_ip ^ translated_ip ^ expected_translated_ip)) begin
                $display("PASS");
                $display("  Outputs: translated_ip=%h",
                         translated_ip);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: translated_ip=%h",
                         expected_translated_ip);
                $display("  Got:      translated_ip=%h",
                         translated_ip);
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
