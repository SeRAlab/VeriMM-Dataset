`timescale 1ns/1ps

module packet_filter_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] dest_ip;
    reg [4:0] src_ip;
    wire allowed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    packet_filter dut (
        .dest_ip(dest_ip),
        .src_ip(src_ip),
        .allowed(allowed)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Valid Packet - Normal Source and Destination IPs", test_num);
        src_ip = 5'b01010;
        dest_ip = 5'b10100;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Denied Packet - Source IP is '00000'", test_num);
        src_ip = 5'b00000;
        dest_ip = 5'b00111;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Denied Packet - Destination IP is '11111'", test_num);
        src_ip = 5'b01111;
        dest_ip = 5'b11111;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Denied Packet - Both Source '00000' and Destination '11111'", test_num);
        src_ip = 5'b00000;
        dest_ip = 5'b11111;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Valid Packet - Source IP is all 1s (allowed), Destination IP is 0 (allowed)", test_num);
        src_ip = 5'b11111;
        dest_ip = 5'b00000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Valid Packet - Minimal change from denied IPs", test_num);
        src_ip = 5'b00001;
        dest_ip = 5'b11110;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Denied Packet - Source IP is '00000', Destination IP is '00000'", test_num);
        src_ip = 5'b00000;
        dest_ip = 5'b00000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Denied Packet - Destination IP is '11111', Source IP is '11111'", test_num);
        src_ip = 5'b11111;
        dest_ip = 5'b11111;
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
