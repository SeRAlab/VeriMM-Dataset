`timescale 1ns/1ps

module NAT_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] dest_ip;
    reg [31:0] src_ip;
    wire [31:0] translated_dest_ip;
    wire [31:0] translated_src_ip;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    NAT dut (
        .dest_ip(dest_ip),
        .src_ip(src_ip),
        .translated_dest_ip(translated_dest_ip),
        .translated_src_ip(translated_src_ip)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Both IPs Match Mapping", test_num);


            src_ip = 32'hC0A8010A;
            dest_ip = 32'hAC100014;
            #1;

            check_outputs(32'h0A000014, 32'h0A00000A);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Only Source IP Matches", test_num);


            src_ip = 32'hC0A8010A;
            dest_ip = 32'h08080808;
            #1;

            check_outputs(32'h08080808, 32'h0A00000A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Only Destination IP Matches", test_num);


            src_ip = 32'h01010101;
            dest_ip = 32'hAC100014;
            #1;

            check_outputs(32'h0A000014, 32'h01010101);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: No IPs Match Mapping", test_num);


            src_ip = 32'h0A000001;
            dest_ip = 32'h0A000002;
            #1;

            check_outputs(32'h0A000002, 32'h0A000001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Field Specificity Check", test_num);


            src_ip = 32'hAC100014;
            dest_ip = 32'hC0A8010A;
            #1;

            check_outputs(32'hC0A8010A, 32'hAC100014);
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
        input [31:0] expected_translated_dest_ip;
        input [31:0] expected_translated_src_ip;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_translated_dest_ip === (expected_translated_dest_ip ^ translated_dest_ip ^ expected_translated_dest_ip) &&
                expected_translated_src_ip === (expected_translated_src_ip ^ translated_src_ip ^ expected_translated_src_ip)) begin
                $display("PASS");
                $display("  Outputs: translated_dest_ip=%h, translated_src_ip=%h",
                         translated_dest_ip, translated_src_ip);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: translated_dest_ip=%h, translated_src_ip=%h",
                         expected_translated_dest_ip, expected_translated_src_ip);
                $display("  Got:      translated_dest_ip=%h, translated_src_ip=%h",
                         translated_dest_ip, translated_src_ip);
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
