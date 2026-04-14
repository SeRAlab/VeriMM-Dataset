`timescale 1ns/1ps

module nat_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] internal_ip;
    reg req;
    reg rst_n;
    wire [31:0] external_ip;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nat dut (
        .clk(clk),
        .internal_ip(internal_ip),
        .req(req),
        .rst_n(rst_n),
        .external_ip(external_ip),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            req = 0;
            internal_ip = 32'h0;
            @(posedge clk);
            #2;
            rst_n = 1;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Valid IP 10.0.0.5");
            reset_dut();
            internal_ip = 32'h0A000005;
            req = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hC0A80101, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Invalid IP 172.16.0.1");
            reset_dut();
            internal_ip = 32'hAC100001;
            req = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h00000000, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Valid IP 10.1.2.3 but req=0");
            reset_dut();
            internal_ip = 32'h0A010203;
            req = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h00000000, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Boundary IP 10.0.0.0");
            reset_dut();
            internal_ip = 32'h0A000000;
            req = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hC0A80101, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Boundary IP 10.255.255.255");
            reset_dut();
            internal_ip = 32'h0AFFFFFF;
            req = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hC0A80101, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Out-of-range IP 11.0.0.1");
            reset_dut();
            internal_ip = 32'h0B000001;
            req = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h00000000, 1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Multiple valid requests");
            reset_dut();


            internal_ip = 32'h0A000001;
            req = 1;
            @(posedge clk);
            #2;


            internal_ip = 32'h0A000002;
            req = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hC0A80101, 1'b1);
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
        input expected_valid;
        begin
            if (expected_external_ip === (expected_external_ip ^ external_ip ^ expected_external_ip) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: external_ip=%h, valid=%b",
                         external_ip, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: external_ip=%h, valid=%b",
                         expected_external_ip, expected_valid);
                $display("  Got:      external_ip=%h, valid=%b",
                         external_ip, valid);
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
        $dumpvars(0,clk, internal_ip, req, rst_n, external_ip, valid);
    end

endmodule
