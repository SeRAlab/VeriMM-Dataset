`timescale 1ns/1ps

module packet_filter_tb;

    // Testbench signals (combinational circuit)
    reg allow_control;
    reg [31:0] dst_ip;
    reg [31:0] src_ip;
    wire packet_allowed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    packet_filter dut (
        .allow_control(allow_control),
        .dst_ip(dst_ip),
        .src_ip(src_ip),
        .packet_allowed(packet_allowed)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Allowed IP (192.168.1.1) with allow_control=1", test_num);
            src_ip = 32'hC0A80101;
            dst_ip = 32'h08080808;
            allow_control = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Allowed IP (192.168.1.1) with allow_control=0", test_num);
            src_ip = 32'hC0A80101;
            dst_ip = 32'h08080808;
            allow_control = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Second Allowed IP (10.0.0.1) with allow_control=1", test_num);
            src_ip = 32'h0A000001;
            dst_ip = 32'hC0A80102;
            allow_control = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Disallowed IP (172.16.0.1) with allow_control=1", test_num);
            src_ip = 32'hAC100001;
            dst_ip = 32'h08080808;
            allow_control = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Public IP (8.8.8.8) with allow_control=1", test_num);
            src_ip = 32'h08080808;
            dst_ip = 32'h0A000001;
            allow_control = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All-zero IP with allow_control=1", test_num);
            src_ip = 32'h00000000;
            dst_ip = 32'h00000000;
            allow_control = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Disallowed IP with allow_control=0", test_num);
            src_ip = 32'hFFFFFFFF;
            dst_ip = 32'hC0A80101;
            allow_control = 1'b0;
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
        $display("packet_filter Testbench");
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
        input expected_packet_allowed;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_packet_allowed === (expected_packet_allowed ^ packet_allowed ^ expected_packet_allowed)) begin
                $display("PASS");
                $display("  Outputs: packet_allowed=%b",
                         packet_allowed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: packet_allowed=%b",
                         expected_packet_allowed);
                $display("  Got:      packet_allowed=%b",
                         packet_allowed);
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
