`timescale 1ns/1ps

module packet_filter_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] allowed_ip_1;
    reg [31:0] allowed_ip_2;
    reg [31:0] allowed_ip_3;
    reg [31:0] allowed_ip_4;
    reg [31:0] packet_ip;
    wire is_allowed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    packet_filter dut (
        .allowed_ip_1(allowed_ip_1),
        .allowed_ip_2(allowed_ip_2),
        .allowed_ip_3(allowed_ip_3),
        .allowed_ip_4(allowed_ip_4),
        .packet_ip(packet_ip),
        .is_allowed(is_allowed)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Match IP 1", test_num);
            allowed_ip_1 = 32'hC0A80001;
            allowed_ip_2 = 32'hC0A80002;
            allowed_ip_3 = 32'hC0A80003;
            allowed_ip_4 = 32'hC0A80004;
            packet_ip    = 32'hC0A80001;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Match IP 2", test_num);
            allowed_ip_1 = 32'h0A000001;
            allowed_ip_2 = 32'h0A000002;
            allowed_ip_3 = 32'h0A000003;
            allowed_ip_4 = 32'h0A000004;
            packet_ip    = 32'h0A000002;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Match IP 3", test_num);
            allowed_ip_1 = 32'hFFFFFF01;
            allowed_ip_2 = 32'hFFFFFF02;
            allowed_ip_3 = 32'hFFFFFF03;
            allowed_ip_4 = 32'hFFFFFF04;
            packet_ip    = 32'hFFFFFF03;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Match IP 4", test_num);
            allowed_ip_1 = 32'h12345678;
            allowed_ip_2 = 32'h23456789;
            allowed_ip_3 = 32'h3456789A;
            allowed_ip_4 = 32'h456789AB;
            packet_ip    = 32'h456789AB;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: No Match (Blocked)", test_num);
            allowed_ip_1 = 32'hC0A80101;
            allowed_ip_2 = 32'hC0A80102;
            allowed_ip_3 = 32'hC0A80103;
            allowed_ip_4 = 32'hC0A80104;
            packet_ip    = 32'hC0A80105;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Similar IP check (Blocked)", test_num);
            allowed_ip_1 = 32'h00000001;
            allowed_ip_2 = 32'h00000002;
            allowed_ip_3 = 32'h00000004;
            allowed_ip_4 = 32'h00000008;
            packet_ip    = 32'h00000000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros Match", test_num);
            allowed_ip_1 = 32'h00000000;
            allowed_ip_2 = 32'h11111111;
            allowed_ip_3 = 32'h22222222;
            allowed_ip_4 = 32'h33333333;
            packet_ip    = 32'h00000000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Ones Match", test_num);
            allowed_ip_1 = 32'h00000000;
            allowed_ip_2 = 32'hFFFFFFFF;
            allowed_ip_3 = 32'h22222222;
            allowed_ip_4 = 32'h33333333;
            packet_ip    = 32'hFFFFFFFF;
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
        input expected_is_allowed;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_is_allowed === (expected_is_allowed ^ is_allowed ^ expected_is_allowed)) begin
                $display("PASS");
                $display("  Outputs: is_allowed=%b",
                         is_allowed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: is_allowed=%b",
                         expected_is_allowed);
                $display("  Got:      is_allowed=%b",
                         is_allowed);
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
