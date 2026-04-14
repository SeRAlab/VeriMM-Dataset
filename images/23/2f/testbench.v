`timescale 1ns/1ps

module nat_translation_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] private_ip;
    reg request;
    reg reset;
    wire [31:0] public_ip;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nat_translation dut (
        .clk(clk),
        .private_ip(private_ip),
        .request(request),
        .reset(reset),
        .public_ip(public_ip)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            request = 0;
            private_ip = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Translate 192.168.1.1");
            reset_dut();
            test_num = 1;
            private_ip = 32'hC0A80101;
            request = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hCB007101);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Translate 192.168.1.10");
            reset_dut();
            test_num = 2;
            private_ip = 32'hC0A8010A;
            request = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hCB00710A);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Translate 10.0.0.5");
            reset_dut();
            test_num = 3;
            private_ip = 32'h0A000005;
            request = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hCB007132);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Request signal low");
            reset_dut();
            test_num = 4;
            private_ip = 32'hC0A80101;
            request = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Unmapped IP address");
            reset_dut();
            test_num = 5;
            private_ip = 32'hAC100001;
            request = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Reset during operation");
            reset_dut();
            test_num = 6;
            private_ip = 32'hC0A80101;
            request = 1;
            @(posedge clk);
            #1;
            reset = 1;
            @(posedge clk);
            #2;
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
        $display("nat_translation Testbench");
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
        $dumpvars(0,clk, private_ip, request, reset, public_ip);
    end

endmodule
