`timescale 1ns/1ps

module NAT_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] external_ip;
    reg [15:0] external_port;
    reg [31:0] internal_ip;
    reg [15:0] internal_port;
    reg reset;
    wire [31:0] mapped_external_ip;
    wire [15:0] mapped_external_port;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    NAT dut (
        .clk(clk),
        .external_ip(external_ip),
        .external_port(external_port),
        .internal_ip(internal_ip),
        .internal_port(internal_port),
        .reset(reset),
        .mapped_external_ip(mapped_external_ip),
        .mapped_external_port(mapped_external_port)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            external_ip = 32'h0;
            external_port = 16'h0;
            internal_ip = 32'h0;
            internal_port = 16'h0;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Basic Mapping (192.168.1.10 -> 203.0.113.5)", test_num);
            reset_dut();

            internal_ip = 32'hC0A8010A;
            internal_port = 16'h1388;
            external_ip = 32'hCB007105;
            external_port = 16'h0050;

            @(posedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hCB007105, 16'h0050);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: High Port Mapping", test_num);
            reset_dut();

            internal_ip = 32'h0A000001;
            internal_port = 16'hFFFF;
            external_ip = 32'h08080808;
            external_port = 16'hD6D6;

            @(posedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h08080808, 16'hD6D6);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros IP and Port", test_num);
            reset_dut();

            internal_ip = 32'h00000000;
            internal_port = 16'h0000;
            external_ip = 32'h00000000;
            external_port = 16'h0000;

            @(posedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h00000000, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Ones IP and Port", test_num);
            reset_dut();

            internal_ip = 32'hFFFFFFFF;
            internal_port = 16'hFFFF;
            external_ip = 32'hFFFFFFFF;
            external_port = 16'hFFFF;

            @(posedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hFFFFFFFF, 16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Rapid Sequential Input Change", test_num);
            reset_dut();


            internal_ip = 32'h11111111;
            internal_port = 16'h1111;
            external_ip = 32'hAAAAAAAA;
            external_port = 16'hAAAA;

            @(posedge clk);


            internal_ip = 32'h22222222;
            internal_port = 16'h2222;
            external_ip = 32'hBBBBBBBB;
            external_port = 16'hBBBB;


            @(posedge clk);
            #2;
            $display("Checking first result in sequence...");
            #1;

            check_outputs(32'hAAAAAAAA, 16'hAAAA);


            @(posedge clk);
            #2;
            $display("Checking second result in sequence...");
            #1;

            check_outputs(32'hBBBBBBBB, 16'hBBBB);
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
        input [31:0] expected_mapped_external_ip;
        input [15:0] expected_mapped_external_port;
        begin
            if (expected_mapped_external_ip === (expected_mapped_external_ip ^ mapped_external_ip ^ expected_mapped_external_ip) &&
                expected_mapped_external_port === (expected_mapped_external_port ^ mapped_external_port ^ expected_mapped_external_port)) begin
                $display("PASS");
                $display("  Outputs: mapped_external_ip=%h, mapped_external_port=%h",
                         mapped_external_ip, mapped_external_port);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mapped_external_ip=%h, mapped_external_port=%h",
                         expected_mapped_external_ip, expected_mapped_external_port);
                $display("  Got:      mapped_external_ip=%h, mapped_external_port=%h",
                         mapped_external_ip, mapped_external_port);
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
        $dumpvars(0,clk, external_ip, external_port, internal_ip, internal_port, reset, mapped_external_ip, mapped_external_port);
    end

endmodule
