`timescale 1ns/1ps

module NAT_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] external_ip;
    reg [31:0] internal_ip;
    reg [15:0] internal_port;
    wire [15:0] external_port;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    NAT dut (
        .external_ip(external_ip),
        .internal_ip(internal_ip),
        .internal_port(internal_port),
        .external_port(external_port)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Standard Translation", test_num);
            internal_ip = 32'hC0A80101;
            internal_port = 16'd80;
            external_ip = 32'hCB007105;
            #1;

            check_outputs(16'd81);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max Port Boundary", test_num);
            internal_ip = 32'h0A000001;
            internal_port = 16'd65534;
            external_ip = 32'h08080808;
            #1;

            check_outputs(16'd65535);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Port Rollover (Overflow)", test_num);
            internal_ip = 32'hAC100064;
            internal_port = 16'hFFFF;
            external_ip = 32'h01010101;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Port", test_num);
            internal_ip = 32'hC0A8000A;
            internal_port = 16'd0;
            external_ip = 32'h2D4D5455;
            #1;

            check_outputs(16'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Random High Port", test_num);
            internal_ip = 32'h7F000001;
            internal_port = 16'd49152;
            external_ip = 32'hD83AD38E;
            #1;

            check_outputs(16'd49153);
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
        input [15:0] expected_external_port;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_external_port === (expected_external_port ^ external_port ^ expected_external_port)) begin
                $display("PASS");
                $display("  Outputs: external_port=%h",
                         external_port);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: external_port=%h",
                         expected_external_port);
                $display("  Got:      external_port=%h",
                         external_port);
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
