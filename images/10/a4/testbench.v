`timescale 1ns/1ps

module nat_device_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] private_ip;
    reg [15:0] private_port;
    wire [31:0] public_ip;
    wire [15:0] public_port;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nat_device dut (
        .private_ip(private_ip),
        .private_port(private_port),
        .public_ip(public_ip),
        .public_port(public_port)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Testing exact mapping (192.168.1.10:8080 -> 203.0.113.5:80)", test_num);
            private_ip = 32'hC0A8010A;
            private_port = 16'd8080;
            #1;

            check_outputs(32'hCB007105, 16'd80);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Correct IP, wrong port (No translation expected)", test_num);
            private_ip = 32'hC0A8010A;
            private_port = 16'd80;
            #1;

            check_outputs(32'h0, 16'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Incorrect IP, correct port (No translation expected)", test_num);
            private_ip = 32'hC0A8010B;
            private_port = 16'd8080;
            #1;

            check_outputs(32'h0, 16'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Boundary test with zeros (No translation expected)", test_num);
            private_ip = 32'h00000000;
            private_port = 16'h0000;
            #1;

            check_outputs(32'h0, 16'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Arbitrary non-matching address", test_num);
            private_ip = 32'h0A000001;
            private_port = 16'd443;
            #1;

            check_outputs(32'h0, 16'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nat_device Testbench");
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
        input [15:0] expected_public_port;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_public_ip === (expected_public_ip ^ public_ip ^ expected_public_ip) &&
                expected_public_port === (expected_public_port ^ public_port ^ expected_public_port)) begin
                $display("PASS");
                $display("  Outputs: public_ip=%h, public_port=%h",
                         public_ip, public_port);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: public_ip=%h, public_port=%h",
                         expected_public_ip, expected_public_port);
                $display("  Got:      public_ip=%h, public_port=%h",
                         public_ip, public_port);
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
