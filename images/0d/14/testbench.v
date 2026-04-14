`timescale 1ns/1ps

module NAT_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] dest_ip;
    reg [31:0] src_ip;
    wire [31:0] translated_src_ip;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    NAT dut (
        .dest_ip(dest_ip),
        .src_ip(src_ip),
        .translated_src_ip(translated_src_ip)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Translate Private IP 192.168.1.1", test_num);
            src_ip = 32'hC0A80101;
            dest_ip = 32'h08080808;

            #1;


            check_outputs(32'h64400001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Translate Private IP 192.168.1.2", test_num);
            src_ip = 32'hC0A80102;
            dest_ip = 32'h08080808;

            #1;


            check_outputs(32'h64400002);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Translate IP from Different Subnet (10.0.0.5)", test_num);
            src_ip = 32'h0A000005;
            dest_ip = 32'hD0D0D0D0;

            #1;


            check_outputs(32'h64400105);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Translate IP from Subnet (172.16.0.100)", test_num);
            src_ip = 32'hAC100064;
            dest_ip = 32'hC0A80101;

            #1;


            check_outputs(32'h64400264);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: IP Address not in Translation Table (Passthrough)", test_num);
            src_ip = 32'h01020304;
            dest_ip = 32'hFFFFFFFF;

            #1;


            check_outputs(32'h01020304);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify Destination IP does not affect Translation", test_num);
            src_ip = 32'hC0A80101;
            dest_ip = 32'h42424242;

            #1;


            check_outputs(32'h64400001);
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
        input [31:0] expected_translated_src_ip;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_translated_src_ip === (expected_translated_src_ip ^ translated_src_ip ^ expected_translated_src_ip)) begin
                $display("PASS");
                $display("  Outputs: translated_src_ip=%h",
                         translated_src_ip);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: translated_src_ip=%h",
                         expected_translated_src_ip);
                $display("  Got:      translated_src_ip=%h",
                         translated_src_ip);
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
