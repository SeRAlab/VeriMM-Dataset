`timescale 1ns/1ps

module nat_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] internal_ip;
    wire [31:0] external_ip;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nat dut (
        .internal_ip(internal_ip),
        .external_ip(external_ip)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Internal IP 192.168.0.1", test_num);
        internal_ip = 32'hC0A80001;

        #1;


        check_outputs(32'h08080808);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Internal IP 192.168.0.2", test_num);
        internal_ip = 32'hC0A80002;

        #1;


        check_outputs(32'h08080804);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Internal IP 10.0.0.1", test_num);
        internal_ip = 32'h0A000001;

        #1;


        check_outputs(32'h01010101);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Internal IP 172.16.0.1", test_num);
        internal_ip = 32'hAC100001;

        #1;


        check_outputs(32'h04040404);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Unmapped IP (Random address)", test_num);
        internal_ip = 32'hDEADBEEF;

        #1;


        check_outputs(32'h00000000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Boundary case (0.0.0.0)", test_num);
        internal_ip = 32'h00000000;

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
        input [31:0] expected_external_ip;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_external_ip === (expected_external_ip ^ external_ip ^ expected_external_ip)) begin
                $display("PASS");
                $display("  Outputs: external_ip=%h",
                         external_ip);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: external_ip=%h",
                         expected_external_ip);
                $display("  Got:      external_ip=%h",
                         external_ip);
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
