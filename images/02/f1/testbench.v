`timescale 1ns/1ps

module NAT_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] private_ip;
    reg [31:0] public_ip;
    reg reset;
    reg update;
    wire [31:0] current_private_ip;
    wire [31:0] current_public_ip;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    NAT dut (
        .clk(clk),
        .private_ip(private_ip),
        .public_ip(public_ip),
        .reset(reset),
        .update(update),
        .current_private_ip(current_private_ip),
        .current_public_ip(current_public_ip)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        update = 0;
        private_ip = 0;
        public_ip = 0;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Check values after reset");
        reset_dut();

        #1;


        check_outputs(32'h0, 32'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Basic mapping update");
        reset_dut();
        private_ip = 32'hC0A80105;
        public_ip = 32'h08080808;
        update = 1;
        @(posedge clk);
        #1;
        update = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hC0A80105, 32'h08080808);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Ensure no update when update signal is low");
        reset_dut();
        private_ip = 32'h0A000001;
        public_ip = 32'hD0D0D0D0;
        update = 0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'h0, 32'h0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Sequential updates - verify latest value");
        reset_dut();

        private_ip = 32'hC0A80001; public_ip = 32'h01010101;
        update = 1; @(posedge clk); #1;

        private_ip = 32'hC0A80002; public_ip = 32'h02020202;
        @(posedge clk); #1;
        update = 0;
        @(posedge clk); #1;
        #1;

        check_outputs(32'hC0A80002, 32'h02020202);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Persistence check");
        reset_dut();
        private_ip = 32'hAAAAAAAA; public_ip = 32'hBBBBBBBB;
        update = 1; @(posedge clk); #1;
        update = 0;
        private_ip = 32'hFFFFFFFF; public_ip = 32'hEEEEEEEE;
        @(posedge clk); #1;
        @(posedge clk); #1;

        #1;


        check_outputs(32'hAAAAAAAA, 32'hBBBBBBBB);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Reset after valid mapping");
        reset_dut();
        private_ip = 32'h12345678; public_ip = 32'h87654321;
        update = 1; @(posedge clk); #1;
        update = 0; @(posedge clk); #1;

        reset = 1; @(posedge clk); #1;
        reset = 0; @(posedge clk); #1;

        #1;


        check_outputs(32'h0, 32'h0);
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
        input [31:0] expected_current_private_ip;
        input [31:0] expected_current_public_ip;
        begin
            if (expected_current_private_ip === (expected_current_private_ip ^ current_private_ip ^ expected_current_private_ip) &&
                expected_current_public_ip === (expected_current_public_ip ^ current_public_ip ^ expected_current_public_ip)) begin
                $display("PASS");
                $display("  Outputs: current_private_ip=%h, current_public_ip=%h",
                         current_private_ip, current_public_ip);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_private_ip=%h, current_public_ip=%h",
                         expected_current_private_ip, expected_current_public_ip);
                $display("  Got:      current_private_ip=%h, current_public_ip=%h",
                         current_private_ip, current_public_ip);
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
        $dumpvars(0,clk, private_ip, public_ip, reset, update, current_private_ip, current_public_ip);
    end

endmodule
