`timescale 1ns/1ps

module nat_translator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] internal_ip;
    reg [15:0] internal_port;
    reg rst;
    wire [31:0] public_ip;
    wire [15:0] public_port;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nat_translator dut (
        .clk(clk),
        .internal_ip(internal_ip),
        .internal_port(internal_port),
        .rst(rst),
        .public_ip(public_ip),
        .public_port(public_port)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            internal_ip = 0;
            internal_port = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Internal 192.168.1.10:80", test_num);
            reset_dut();
            internal_ip = 32'hC0A8010A;
            internal_port = 16'h0050;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hCB007105, 16'h1F90);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Internal 192.168.1.11:443", test_num);
            reset_dut();
            internal_ip = 32'hC0A8010B;
            internal_port = 16'h01BB;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hCB007105, 16'h2382);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Internal 10.0.0.5:22", test_num);
            reset_dut();
            internal_ip = 32'h0A000005;
            internal_port = 16'h0016;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hCB007101, 16'h08AE);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Non-existent Mapping (172.16.0.1:1234)", test_num);
            reset_dut();
            internal_ip = 32'hAC100001;
            internal_port = 16'h04D2;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h00000000, 16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Verify Reset Clearance", test_num);
            reset_dut();

            internal_ip = 32'hC0A8010A;
            internal_port = 16'h0050;
            @(posedge clk);

            rst = 1;
            @(posedge clk);
            #2;

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
        $display("nat_translator Testbench");
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, internal_ip, internal_port, rst, public_ip, public_port);
    end

endmodule
