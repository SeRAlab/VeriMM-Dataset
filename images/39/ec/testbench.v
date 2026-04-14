`timescale 1ns/1ps

module packet_filter_tb;

    // Testbench signals (combinational circuit)
    reg [255:0] allowed_ips;
    reg [31:0] src_ip;
    wire allow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    packet_filter dut (
        .allowed_ips(allowed_ips),
        .src_ip(src_ip),
        .allow(allow)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Match first IP in the list", test_num);
            allowed_ips = {32'h08080808, 32'h04040404, 32'h03030303, 32'h02020202,
                           32'h01010101, 32'hAAAAAAAA, 32'h55555555, 32'hC0A80001};
            src_ip = 32'hC0A80001;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Match last IP in the list", test_num);
            allowed_ips = {32'hDEADBEEF, 32'h04040404, 32'h03030303, 32'h02020202,
                           32'h01010101, 32'hAAAAAAAA, 32'h55555555, 32'hC0A80001};
            src_ip = 32'hDEADBEEF;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Match a middle IP in the list", test_num);
            allowed_ips = {32'h08080808, 32'h07070707, 32'h06060606, 32'h05050505,
                           32'h04040404, 32'h03030303, 32'h02020202, 32'h01010101};
            src_ip = 32'h04040404;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Source IP not in list (Deny)", test_num);
            allowed_ips = {32'h11111111, 32'h22222222, 32'h33333333, 32'h44444444,
                           32'h55555555, 32'h66666666, 32'h77777777, 32'h88888888};
            src_ip = 32'hFFFFFFFF;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Match with all-zero IP in list", test_num);
            allowed_ips = {32'hFFFFFFFF, 32'h0, 32'h0, 32'h0,
                           32'h0, 32'h0, 32'h0, 32'h0};
            src_ip = 32'h00000000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Match with all-ones IP in list", test_num);
            allowed_ips = {32'hFFFFFFFF, 32'h0, 32'h0, 32'h0,
                           32'h0, 32'h0, 32'h0, 32'h0};
            src_ip = 32'hFFFFFFFF;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Near match (off by one bit)", test_num);
            allowed_ips = {32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000,
                           32'h00000000, 32'h00000000, 32'h00000000, 32'hC0A80001};
            src_ip = 32'hC0A80000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All IPs in list are identical", test_num);
            allowed_ips = {8{32'hA5A5A5A5}};
            src_ip = 32'hA5A5A5A5;
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
