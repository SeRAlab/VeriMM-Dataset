`timescale 1ns/1ps

module NAT_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] private_ip;
    wire [31:0] public_ip;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    NAT dut (
        .private_ip(private_ip),
        .public_ip(public_ip)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Private IP 192.168.1.0 (Start of Range)", test_num);
            private_ip = {8'd192, 8'd168, 8'd1, 8'd0};
            #1;

            check_outputs({8'd203, 8'd0, 8'd113, 8'd0});
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Private IP 192.168.1.255 (End of Range)", test_num);
            private_ip = {8'd192, 8'd168, 8'd1, 8'd255};
            #1;

            check_outputs({8'd203, 8'd0, 8'd113, 8'd255});
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Private IP 192.168.1.10 (Mid Range)", test_num);
            private_ip = {8'd192, 8'd168, 8'd1, 8'd10};
            #1;

            check_outputs({8'd203, 8'd0, 8'd113, 8'd10});
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Private IP 192.168.1.128 (Mid Range)", test_num);
            private_ip = {8'd192, 8'd168, 8'd1, 8'd128};
            #1;

            check_outputs({8'd203, 8'd0, 8'd113, 8'd128});
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Private IP 192.168.1.200 (Mid Range)", test_num);
            private_ip = {8'd192, 8'd168, 8'd1, 8'd200};
            #1;

            check_outputs({8'd203, 8'd0, 8'd113, 8'd200});
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("NAT Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [31:0] expected_public_ip;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_public_ip === (expected_public_ip ^ public_ip ^ expected_public_ip)) begin
                $display("PASS");
                $display("  Outputs: public_ip=%h",
                         public_ip);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: public_ip=%h",
                         expected_public_ip);
                $display("  Got:      public_ip=%h",
                         public_ip);
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
