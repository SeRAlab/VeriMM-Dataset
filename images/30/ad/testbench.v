`timescale 1ns/1ps

module nat_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] private_ip;
    reg translate;
    wire [31:0] public_ip;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nat_module dut (
        .private_ip(private_ip),
        .translate(translate),
        .public_ip(public_ip)
    );

    // Clock generation (10ns period)
    initial begin
        translate = 0;
        forever #5 translate = ~translate;
    end

        task reset_dut;

        begin
            private_ip = 32'h0;

            @(posedge translate);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Private IP 10.0.0.1", test_num);
            reset_dut();
            private_ip = 32'h0A000001;
            @(posedge translate);
            #2;
            #1;

            check_outputs(EXPECTED_PUB_IP);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Private IP 192.168.1.100", test_num);
            reset_dut();
            private_ip = 32'hC0A80164;
            @(posedge translate);
            #2;
            #1;

            check_outputs(EXPECTED_PUB_IP);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Private IP 172.16.50.1", test_num);
            reset_dut();
            private_ip = 32'hAC103201;
            @(posedge translate);
            #2;
            #1;

            check_outputs(EXPECTED_PUB_IP);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Private IP 0.0.0.0", test_num);
            reset_dut();
            private_ip = 32'h00000000;
            @(posedge translate);
            #2;
            #1;

            check_outputs(EXPECTED_PUB_IP);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Private IP 255.255.255.255", test_num);
            reset_dut();
            private_ip = 32'hFFFFFFFF;
            @(posedge translate);
            #2;
            #1;

            check_outputs(EXPECTED_PUB_IP);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Rapid Change to 10.10.10.10", test_num);
            reset_dut();
            private_ip = 32'h0A0A0A0A;
            @(posedge translate);
            #2;
            #1;

            check_outputs(EXPECTED_PUB_IP);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nat_module Testbench");
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,private_ip, translate, public_ip);
    end

endmodule
