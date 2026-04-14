`timescale 1ns/1ps

module NAT_Controller_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] dst_ip;
    reg nat_enable;
    reg [31:0] src_ip;
    wire [31:0] out_dst_ip;
    wire [31:0] out_src_ip;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    NAT_Controller dut (
        .dst_ip(dst_ip),
        .nat_enable(nat_enable),
        .src_ip(src_ip),
        .out_dst_ip(out_dst_ip),
        .out_src_ip(out_src_ip)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: NAT Disabled", test_num);
            nat_enable = 1'b0;
            src_ip = 32'h0A000001;
            dst_ip = 32'h08080808;
            #1;

            check_outputs(32'h08080808, 32'h0A000001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: NAT Enabled", test_num);
            nat_enable = 1'b1;
            src_ip = 32'h0A000001;
            dst_ip = 32'h08080808;

            #1;


            check_outputs(32'h08080808, 32'hC0A80101);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: NAT Disabled (Different IPs)", test_num);
            nat_enable = 1'b0;
            src_ip = 32'hFFFFFFFF;
            dst_ip = 32'h12345678;
            #1;

            check_outputs(32'h12345678, 32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: NAT Enabled (Different IPs)", test_num);
            nat_enable = 1'b1;
            src_ip = 32'h00000000;
            dst_ip = 32'hDEADBEEF;

            #1;


            check_outputs(32'hDEADBEEF, 32'hC0A80101);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Toggle NAT Enable Verification", test_num);
            src_ip = 32'hC0A80064;
            dst_ip = 32'h01010101;


            nat_enable = 1'b0;
            #2;


            nat_enable = 1'b1;
            #1;

            check_outputs(32'h01010101, 32'hC0A80101);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("NAT_Controller Testbench");
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
        input [31:0] expected_out_dst_ip;
        input [31:0] expected_out_src_ip;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_dst_ip === (expected_out_dst_ip ^ out_dst_ip ^ expected_out_dst_ip) &&
                expected_out_src_ip === (expected_out_src_ip ^ out_src_ip ^ expected_out_src_ip)) begin
                $display("PASS");
                $display("  Outputs: out_dst_ip=%h, out_src_ip=%h",
                         out_dst_ip, out_src_ip);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_dst_ip=%h, out_src_ip=%h",
                         expected_out_dst_ip, expected_out_src_ip);
                $display("  Got:      out_dst_ip=%h, out_src_ip=%h",
                         out_dst_ip, out_src_ip);
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
