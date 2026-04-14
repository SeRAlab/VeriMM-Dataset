`timescale 1ns/1ps

module packet_filter_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] dest_ip;
    reg [7:0] protocol;
    reg [31:0] src_ip;
    wire [7:0] action;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    packet_filter dut (
        .dest_ip(dest_ip),
        .protocol(protocol),
        .src_ip(src_ip),
        .action(action)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Exact match Rule 1 (192.168.1.1 -> 10.0.0.1, TCP)", test_num);
        src_ip   = 32'hC0A80101;
        dest_ip  = 32'h0A000001;
        protocol = 8'h06;
        #1;

        check_outputs(ALLOW);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Exact match Rule 2 (192.168.1.2 -> 10.0.0.2, UDP)", test_num);
        src_ip   = 32'hC0A80102;
        dest_ip  = 32'h0A000002;
        protocol = 8'h11;
        #1;

        check_outputs(ALLOW);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Exact match Rule 3 (172.16.0.5 -> 172.16.0.10, ICMP)", test_num);
        src_ip   = 32'hAC100005;
        dest_ip  = 32'hAC10000A;
        protocol = 8'h01;
        #1;

        check_outputs(ALLOW);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Exact match Rule 4 (8.8.8.8 -> 4.4.4.4, TCP)", test_num);
        src_ip   = 32'h08080808;
        dest_ip  = 32'h04040404;
        protocol = 8'h06;
        #1;

        check_outputs(ALLOW);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: No match - Random packet", test_num);
        src_ip   = 32'h01020304;
        dest_ip  = 32'h05060708;
        protocol = 8'hFF;
        #1;

        check_outputs(BLOCK);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Partial match - Wrong Protocol", test_num);
        src_ip   = 32'hC0A80101;
        dest_ip  = 32'h0A000001;
        protocol = 8'h11;
        #1;

        check_outputs(BLOCK);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Partial match - Wrong Destination IP", test_num);
        src_ip   = 32'hAC100005;
        dest_ip  = 32'hFFFFFFFF;
        protocol = 8'h01;
        #1;

        check_outputs(BLOCK);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All zeros input check", test_num);
        src_ip   = 32'h0;
        dest_ip  = 32'h0;
        protocol = 8'h0;
        #1;

        check_outputs(BLOCK);
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
        input [7:0] expected_action;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_action === (expected_action ^ action ^ expected_action)) begin
                $display("PASS");
                $display("  Outputs: action=%h",
                         action);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: action=%h",
                         expected_action);
                $display("  Got:      action=%h",
                         action);
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
