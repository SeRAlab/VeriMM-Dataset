`timescale 1ns/1ps

module nat_pat_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] internal_ip;
    reg [15:0] internal_port;
    reg reset;
    wire [31:0] external_ip;
    wire [15:0] external_port;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nat_pat dut (
        .clk(clk),
        .internal_ip(internal_ip),
        .internal_port(internal_port),
        .reset(reset),
        .external_ip(external_ip),
        .external_port(external_port)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            internal_ip = 32'h0;
            internal_port = 16'h0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Initial translation after reset...", test_num);
            reset_dut();

            internal_ip = 32'hC0A80001;
            internal_port = 16'd80;


            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h01020304, 16'd1024);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Sequential port incrementing...", test_num);
            reset_dut();


            internal_ip = 32'hC0A80001;
            internal_port = 16'd80;
            @(posedge clk);


            internal_ip = 32'hC0A80002;
            internal_port = 16'd80;
            @(posedge clk);

            #1;
            #1;

            check_outputs(32'h01020304, 16'd1025);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Different internal port same IP...", test_num);
            reset_dut();


            internal_ip = 32'hC0A80164;
            internal_port = 16'd1000;
            @(posedge clk);


            internal_ip = 32'hC0A80164;
            internal_port = 16'd2000;
            @(posedge clk);


            internal_ip = 32'hC0A80164;
            internal_port = 16'd3000;
            @(posedge clk);

            #1;
            #1;

            check_outputs(32'h01020304, 16'd1026);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Reset restart verification...", test_num);


            reset_dut();
            repeat(5) @(posedge clk);


            reset_dut();
            internal_ip = 32'h0A000005;
            internal_port = 16'd443;
            @(posedge clk);

            #1;
            #1;

            check_outputs(32'h01020304, 16'd1024);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nat_pat Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, internal_ip, internal_port, reset, external_ip, external_port);
    end

endmodule
