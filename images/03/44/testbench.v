`timescale 1ns/1ps

module packet_filter_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] allowed_ip_1;
    reg [31:0] allowed_ip_2;
    reg [31:0] allowed_ip_3;
    reg [31:0] packet_ip;
    wire allowed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    packet_filter dut (
        .allowed_ip_1(allowed_ip_1),
        .allowed_ip_2(allowed_ip_2),
        .allowed_ip_3(allowed_ip_3),
        .packet_ip(packet_ip),
        .allowed(allowed)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Packet matches allowed_ip_1", test_num);
            allowed_ip_1 = 32'hC0A80001;
            allowed_ip_2 = 32'hC0A80002;
            allowed_ip_3 = 32'hC0A80003;
            packet_ip    = 32'hC0A80001;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Packet matches allowed_ip_2", test_num);
            allowed_ip_1 = 32'h0A000001;
            allowed_ip_2 = 32'h0A000002;
            allowed_ip_3 = 32'h0A000003;
            packet_ip    = 32'h0A000002;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Packet matches allowed_ip_3", test_num);
            allowed_ip_1 = 32'hFFFFFFFF;
            allowed_ip_2 = 32'hEEEEEEEE;
            allowed_ip_3 = 32'hDDDDDDDD;
            packet_ip    = 32'hDDDDDDDD;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Packet does not match any allowed IPs", test_num);
            allowed_ip_1 = 32'h11111111;
            allowed_ip_2 = 32'h22222222;
            allowed_ip_3 = 32'h33333333;
            packet_ip    = 32'h44444444;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary check - all zeros", test_num);
            allowed_ip_1 = 32'h00000000;
            allowed_ip_2 = 32'h11111111;
            allowed_ip_3 = 32'h22222222;
            packet_ip    = 32'h00000000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary check - all ones", test_num);
            allowed_ip_1 = 32'hAAAAAAAA;
            allowed_ip_2 = 32'hBBBBBBBB;
            allowed_ip_3 = 32'hFFFFFFFF;
            packet_ip    = 32'hFFFFFFFF;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single bit difference (Blocked)", test_num);
            allowed_ip_1 = 32'hC0A80001;
            allowed_ip_2 = 32'hC0A80002;
            allowed_ip_3 = 32'hC0A80003;
            packet_ip    = 32'hC0A80000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Duplicate allowed IPs (Allowed)", test_num);
            allowed_ip_1 = 32'h12345678;
            allowed_ip_2 = 32'h12345678;
            allowed_ip_3 = 32'h87654321;
            packet_ip    = 32'h12345678;
            #1;

            check_outputs(1'b1);
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
