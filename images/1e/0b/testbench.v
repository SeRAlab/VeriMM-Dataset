`timescale 1ns/1ps

module NAT_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg control;
    reg [31:0] external_ip;
    reg [31:0] internal_ip;
    reg reset;
    wire [31:0] translated_ip;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    NAT dut (
        .clk(clk),
        .control(control),
        .external_ip(external_ip),
        .internal_ip(internal_ip),
        .reset(reset),
        .translated_ip(translated_ip)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        control = 0;
        internal_ip = 32'h00000000;
        external_ip = 32'h00000000;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Control Low - Should output Internal IP", test_num);
        reset_dut();
        internal_ip = 32'hC0A80105;
        external_ip = 32'h08080808;
        control = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hC0A80105);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Control High - Should output External IP", test_num);
        reset_dut();
        internal_ip = 32'h0A000001;
        external_ip = 32'hD83AD38E;
        control = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hD83AD38E);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Reset Priority - Should revert to Internal IP even if Control is High", test_num);
        reset_dut();
        internal_ip = 32'hC0A80001;
        external_ip = 32'h01020304;
        control = 1;
        @(posedge clk);
        #1;

        if (translated_ip !== external_ip) $display("  Note: Intermediate state not external");


        reset = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hC0A80001);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Dynamic Control Switching", test_num);
        reset_dut();
        internal_ip = 32'h11223344;
        external_ip = 32'h55667788;


        control = 1;
        @(posedge clk);
        #1;


        control = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h11223344);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Boundary IP values", test_num);
        reset_dut();
        internal_ip = 32'hFFFFFFFF;
        external_ip = 32'h00000000;

        control = 1;
        @(posedge clk);
        #1;
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
        $dumpvars(0,clk, control, external_ip, internal_ip, reset, translated_ip);
    end

endmodule
