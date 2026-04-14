`timescale 1ns/1ps

module NAT_Translation_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] internal_ip;
    wire [31:0] public_ip;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    NAT_Translation dut (
        .internal_ip(internal_ip),
        .public_ip(public_ip)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Start (192.168.0.0)", test_num);
            internal_ip = 32'hC0A80000;
            #1;

            check_outputs(32'hCB007101);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary End (192.168.255.255)", test_num);
            internal_ip = 32'hC0A8FFFF;
            #1;

            check_outputs(32'hCB007101);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Inside Range (192.168.10.20)", test_num);
            internal_ip = 32'hC0A80A14;
            #1;

            check_outputs(32'hCB007101);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Just Below Range (192.167.255.255)", test_num);
            internal_ip = 32'hC0A7FFFF;
            #1;

            check_outputs(32'hC0A7FFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Just Above Range (192.169.0.0)", test_num);
            internal_ip = 32'hC0A90000;
            #1;

            check_outputs(32'hC0A90000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Public IP (8.8.8.8)", test_num);
            internal_ip = 32'h08080808;
            #1;

            check_outputs(32'h08080808);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros (0.0.0.0)", test_num);
            internal_ip = 32'h00000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Ones (255.255.255.255)", test_num);
            internal_ip = 32'hFFFFFFFF;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("NAT_Translation Testbench");
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
