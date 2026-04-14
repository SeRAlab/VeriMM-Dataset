`timescale 1ns/1ps

module packet_filter_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] dest_ip;
    reg [1:0] protocol;
    reg [7:0] src_ip;
    wire accept;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    packet_filter dut (
        .dest_ip(dest_ip),
        .protocol(protocol),
        .src_ip(src_ip),
        .accept(accept)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Valid TCP packet (AA -> BB, protocol 00)", test_num);
            src_ip = 8'hAA;
            dest_ip = 8'hBB;
            protocol = 2'b00;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Valid UDP packet (CC -> DD, protocol 01)", test_num);
            src_ip = 8'hCC;
            dest_ip = 8'hDD;
            protocol = 2'b01;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Correct TCP IPs but wrong protocol (UDP instead of TCP)", test_num);
            src_ip = 8'hAA;
            dest_ip = 8'hBB;
            protocol = 2'b01;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Correct UDP IPs but wrong protocol (TCP instead of UDP)", test_num);
            src_ip = 8'hCC;
            dest_ip = 8'hDD;
            protocol = 2'b00;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Correct TCP src_ip and protocol, but wrong dest_ip", test_num);
            src_ip = 8'hAA;
            dest_ip = 8'hFF;
            protocol = 2'b00;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Correct UDP dest_ip and protocol, but wrong src_ip", test_num);
            src_ip = 8'h00;
            dest_ip = 8'hDD;
            protocol = 2'b01;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: ICMP protocol (protocol 10) with valid TCP IPs", test_num);
            src_ip = 8'hAA;
            dest_ip = 8'hBB;
            protocol = 2'b10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Other protocol (protocol 11) with valid UDP IPs", test_num);
            src_ip = 8'hCC;
            dest_ip = 8'hDD;
            protocol = 2'b11;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Completely unrelated packet", test_num);
            src_ip = 8'h12;
            dest_ip = 8'h34;
            protocol = 2'b00;
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
        input expected_accept;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_accept === (expected_accept ^ accept ^ expected_accept)) begin
                $display("PASS");
                $display("  Outputs: accept=%b",
                         accept);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: accept=%b",
                         expected_accept);
                $display("  Got:      accept=%b",
                         accept);
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
