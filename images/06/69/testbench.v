`timescale 1ns/1ps

module NAT_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] private_ip;
    reg rst;
    wire [31:0] public_ip;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    NAT dut (
        .clk(clk),
        .private_ip(private_ip),
        .rst(rst),
        .public_ip(public_ip)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            private_ip = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Private 192.168.1.1 -> Public 100.64.1.1");
            reset_dut();
            private_ip = 32'hC0A80101;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h64400101);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Private 192.168.1.254 -> Public 100.64.1.254");
            reset_dut();
            private_ip = 32'hC0A801FE;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h644001FE);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Private 10.0.0.50 -> Public 203.0.113.50");
            reset_dut();
            private_ip = 32'h0A000032;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hCB007132);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Private 10.0.0.255 -> Public 203.0.113.255");
            reset_dut();
            private_ip = 32'h0A0000FF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hCB0071FF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Unmapped IP 172.16.0.1 -> 0.0.0.0 (Null Mapping)");
            reset_dut();
            private_ip = 32'hAC100001;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Sequential update check (192.168.1.5)");
            reset_dut();
            private_ip = 32'hC0A80105;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h64400105);
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
        $dumpvars(0,clk, private_ip, rst, public_ip);
    end

endmodule
