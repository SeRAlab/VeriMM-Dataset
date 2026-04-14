`timescale 1ns/1ps

module nat_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] private_ip;
    wire [31:0] public_ip;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nat dut (
        .private_ip(private_ip),
        .public_ip(public_ip)
    );
    task testcase001;

        begin
            test_num = 1;
            private_ip = 32'hC0A80000;
            $display("Test %0d: Private IP = 192.168.0.0", test_num);
            #1;

            check_outputs(32'hCB007101);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            private_ip = 32'hC0A8FFFF;
            $display("Test %0d: Private IP = 192.168.255.255", test_num);
            #1;

            check_outputs(32'hCB007101);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            private_ip = 32'hC0A80A32;
            $display("Test %0d: Private IP = 192.168.10.50", test_num);
            #1;

            check_outputs(32'hCB007101);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            private_ip = 32'hC0A7FFFF;
            $display("Test %0d: Private IP = 192.167.255.255", test_num);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            private_ip = 32'hC0A90000;
            $display("Test %0d: Private IP = 192.169.0.0", test_num);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            private_ip = 32'hBFA80000;
            $display("Test %0d: Private IP = 191.168.0.0", test_num);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            private_ip = 32'h08080808;
            $display("Test %0d: Private IP = 8.8.8.8", test_num);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            private_ip = 32'h00000000;
            $display("Test %0d: Private IP = 0.0.0.0", test_num);
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
        $display("nat Testbench");
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
