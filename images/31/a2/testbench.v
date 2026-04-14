`timescale 1ns/1ps

module packet_filter_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] dest_ip;
    reg [15:0] src_ip;
    wire allow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    packet_filter dut (
        .dest_ip(dest_ip),
        .src_ip(src_ip),
        .allow(allow)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Lower boundary source IP (192.168.0.1) and correct destination IP (192.168.0.10)", test_num);
            src_ip = 16'h0001;
            dest_ip = 16'h000A;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Upper boundary source IP (192.168.0.255) and correct destination IP (192.168.0.10)", test_num);
            src_ip = 16'h00FF;
            dest_ip = 16'h000A;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mid-range source IP (192.168.0.128) and correct destination IP (192.168.0.10)", test_num);
            src_ip = 16'h0080;
            dest_ip = 16'h000A;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Source IP just below range (192.168.0.0) and correct destination IP (192.168.0.10)", test_num);
            src_ip = 16'h0000;
            dest_ip = 16'h000A;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Source IP just above range (192.168.1.0 / 256) and correct destination IP (192.168.0.10)", test_num);
            src_ip = 16'h0100;
            dest_ip = 16'h000A;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Correct source IP (192.168.0.10) but incorrect destination IP (192.168.0.11)", test_num);
            src_ip = 16'h000A;
            dest_ip = 16'h000B;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Correct source IP (192.168.0.10) but incorrect destination IP (192.168.0.9)", test_num);
            src_ip = 16'h000A;
            dest_ip = 16'h0009;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Source IP at max 16-bit value and correct destination IP", test_num);
            src_ip = 16'hFFFF;
            dest_ip = 16'h000A;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Correct source IP but destination IP at max 16-bit value", test_num);
            src_ip = 16'h0010;
            dest_ip = 16'hFFFF;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Both source and destination IPs completely out of bounds", test_num);
            src_ip = 16'hAABB;
            dest_ip = 16'hCCDD;
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
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input expected_allow;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_allow === (expected_allow ^ allow ^ expected_allow)) begin
                $display("PASS");
                $display("  Outputs: allow=%b",
                         allow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: allow=%b",
                         expected_allow);
                $display("  Got:      allow=%b",
                         allow);
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
