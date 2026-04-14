`timescale 1ns/1ps

module NAT_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] public_ip;
    wire [31:0] private_ip;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    NAT dut (
        .public_ip(public_ip),
        .private_ip(private_ip)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Standard IP Translation (8.8.8.8)", test_num);
            public_ip = 32'h08080808;

            #1;


            check_outputs(32'hF7F7F7F7);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Translation of 192.168.1.1", test_num);
            public_ip = 32'hC0A80101;

            #1;


            check_outputs(32'h3F57FEFE);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Edge Case All Zeros", test_num);
            public_ip = 32'h00000000;

            #1;


            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Edge Case All Ones", test_num);
            public_ip = 32'hFFFFFFFF;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Alternating Bit Pattern", test_num);
            public_ip = 32'hAAAAAAAA;

            #1;


            check_outputs(32'h55555555);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: High-Byte Specific IP", test_num);
            public_ip = 32'hFF000000;

            #1;


            check_outputs(32'h00FFFFFF);
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
        input [31:0] expected_private_ip;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_private_ip === (expected_private_ip ^ private_ip ^ expected_private_ip)) begin
                $display("PASS");
                $display("  Outputs: private_ip=%h",
                         private_ip);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: private_ip=%h",
                         expected_private_ip);
                $display("  Got:      private_ip=%h",
                         private_ip);
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
