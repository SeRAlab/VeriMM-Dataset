`timescale 1ns/1ps

module packet_filter_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] dest_port;
    reg [31:0] src_ip;
    wire allowed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    packet_filter dut (
        .dest_port(dest_port),
        .src_ip(src_ip),
        .allowed(allowed)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Valid IP 1 (192.168.1.1) and Valid Port (80)", test_num);
        src_ip = 32'hC0A80101;
        dest_port = 16'd80;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Valid IP 2 (192.168.1.2) and Valid Port (80)", test_num);
        src_ip = 32'hC0A80102;
        dest_port = 16'd80;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Valid IP 1 (192.168.1.1) but Invalid Port (443)", test_num);
        src_ip = 32'hC0A80101;
        dest_port = 16'd443;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Valid IP 2 (192.168.1.2) but Invalid Port (22)", test_num);
        src_ip = 32'hC0A80102;
        dest_port = 16'd22;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Invalid IP (192.168.1.3) with Valid Port (80)", test_num);
        src_ip = 32'hC0A80103;
        dest_port = 16'd80;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Invalid IP (10.0.0.1) with Valid Port (80)", test_num);
        src_ip = 32'h0A000001;
        dest_port = 16'd80;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Invalid IP and Invalid Port", test_num);
        src_ip = 32'hFFFFFFFF;
        dest_port = 16'hFFFF;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Edge case zeros", test_num);
        src_ip = 32'h00000000;
        dest_port = 16'd0;
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
