`timescale 1ns/1ps

module NAT_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] external_ip;
    reg [31:0] internal_ip;
    reg request;
    reg rst;
    wire [31:0] translated_ip;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    NAT dut (
        .clk(clk),
        .external_ip(external_ip),
        .internal_ip(internal_ip),
        .request(request),
        .rst(rst),
        .translated_ip(translated_ip)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            request = 0;
            internal_ip = 32'b0;
            external_ip = 32'b0;
            #20;
            rst = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Internal IP 192.168.1.10 translation...");
            reset_dut();
            internal_ip = 32'hC0A8010A;
            external_ip = 32'h0;
            request = 1;
            @(posedge clk);
            request = 0;


            repeat(5) @(posedge clk);

            #1;


            check_outputs(32'hCB00710A);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Internal IP 192.168.1.20 translation...");
            reset_dut();
            internal_ip = 32'hC0A80114;
            external_ip = 32'h0;
            request = 1;
            @(posedge clk);
            request = 0;

            repeat(5) @(posedge clk);

            #1;


            check_outputs(32'hCB007114);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Internal IP 10.0.0.5 translation...");
            reset_dut();
            internal_ip = 32'h0A000005;
            external_ip = 32'h0;
            request = 1;
            @(posedge clk);
            request = 0;

            repeat(5) @(posedge clk);

            #1;


            check_outputs(32'h08080808);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Unknown IP address translation...");
            reset_dut();
            internal_ip = 32'hAC100001;
            external_ip = 32'h0;
            request = 1;
            @(posedge clk);
            request = 0;

            repeat(5) @(posedge clk);


            #1;



            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Idle state after reset...");
            reset_dut();

            repeat(2) @(posedge clk);


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
        input [31:0] expected_translated_ip;
        begin
            if (expected_translated_ip === (expected_translated_ip ^ translated_ip ^ expected_translated_ip)) begin
                $display("PASS");
                $display("  Outputs: translated_ip=%h",
                         translated_ip);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: translated_ip=%h",
                         expected_translated_ip);
                $display("  Got:      translated_ip=%h",
                         translated_ip);
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
        $dumpvars(0,clk, external_ip, internal_ip, request, rst, translated_ip);
    end

endmodule
