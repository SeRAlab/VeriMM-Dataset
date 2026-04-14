`timescale 1ns/1ps

module NAT_Converter_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] private_ip;
    wire [31:0] public_ip;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    NAT_Converter dut (
        .private_ip(private_ip),
        .public_ip(public_ip)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Private IP 192.168.1.1 (Class C Range)", test_num);
        private_ip = 32'hC0A80101;
        #1;

        check_outputs(32'hCB007101);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Private IP 192.168.1.254 (Class C Range Upper Bound)", test_num);
        private_ip = 32'hC0A801FE;
        #1;

        check_outputs(32'hCB0071FE);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Private IP 10.0.0.15 (Class A Range)", test_num);
        private_ip = 32'h0A00000F;
        #1;

        check_outputs(32'h0808080F);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Private IP 10.0.0.255 (Class A Broadcast)", test_num);
        private_ip = 32'h0A0000FF;
        #1;

        check_outputs(32'h080808FF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Unmapped Private IP (172.16.0.1)", test_num);
        private_ip = 32'hAC100001;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero IP input", test_num);
        private_ip = 32'h00000000;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("NAT_Converter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
