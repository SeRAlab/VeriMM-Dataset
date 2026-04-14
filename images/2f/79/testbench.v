`timescale 1ns/1ps

module packet_filter_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] src_ip;
    wire allow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    packet_filter dut (
        .src_ip(src_ip),
        .allow(allow)
    );
    task testcase001;

    begin
        $display("Testcase 001: Testing Allowed IP 192.168.1.1");
        src_ip = 32'hC0A80101;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Testing Allowed IP 10.0.0.1");
        src_ip = 32'h0A000001;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Testing Blocked IP (Similar to allowed) 192.168.1.2");
        src_ip = 32'hC0A80102;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Testing Blocked IP (Similar to allowed) 10.0.0.0");
        src_ip = 32'h0A000000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Testing Blocked IP 8.8.8.8");
        src_ip = 32'h08080808;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Testing Blocked IP 0.0.0.0");
        src_ip = 32'h00000000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Testing Blocked IP 255.255.255.255");
        src_ip = 32'hFFFFFFFF;
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
