`timescale 1ns/1ps

module nat_system_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] internal_ip;
    reg [15:0] internal_port;
    wire [31:0] external_ip;
    wire [15:0] external_port;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nat_system dut (
        .internal_ip(internal_ip),
        .internal_port(internal_port),
        .external_ip(external_ip),
        .external_port(external_port)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Internal 192.168.1.100:8080 -> External 203.0.113.1:10001", test_num);

            internal_ip = 32'hC0A80164;
            internal_port = 16'd8080;


            #1;



            check_outputs(32'hCB007101, 16'd10001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Internal 192.168.1.101:8080 -> External 203.0.113.1:10002", test_num);

            internal_ip = 32'hC0A80165;
            internal_port = 16'd8080;


            #1;



            check_outputs(32'hCB007101, 16'd10002);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Internal 10.0.0.1:443 -> External 203.0.113.5:443", test_num);

            internal_ip = 32'h0A000001;
            internal_port = 16'd443;


            #1;



            check_outputs(32'hCB007105, 16'd443);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Internal 172.16.0.10:1234 -> External 203.0.113.10:5678", test_num);

            internal_ip = 32'hAC10000A;
            internal_port = 16'd1234;


            #1;



            check_outputs(32'hCB00710A, 16'd5678);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Unmapped Address (Input not in NAT table)", test_num);

            internal_ip = 32'h01010101;
            internal_port = 16'd1;



            #1;




            check_outputs(32'h00000000, 16'h0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nat_system Testbench");
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
        input [31:0] expected_external_ip;
        input [15:0] expected_external_port;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_external_ip === (expected_external_ip ^ external_ip ^ expected_external_ip) &&
                expected_external_port === (expected_external_port ^ external_port ^ expected_external_port)) begin
                $display("PASS");
                $display("  Outputs: external_ip=%h, external_port=%h",
                         external_ip, external_port);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: external_ip=%h, external_port=%h",
                         expected_external_ip, expected_external_port);
                $display("  Got:      external_ip=%h, external_port=%h",
                         external_ip, external_port);
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
