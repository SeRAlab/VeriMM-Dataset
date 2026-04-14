`timescale 1ns/1ps

module nat_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] dest_ip;
    reg reset;
    reg [31:0] src_ip;
    wire [31:0] nat_ip;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nat dut (
        .clk(clk),
        .dest_ip(dest_ip),
        .reset(reset),
        .src_ip(src_ip),
        .nat_ip(nat_ip)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            src_ip = 0;
            dest_ip = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple NAT Translation for 192.168.1.1", test_num);
            reset_dut();
            src_ip = 32'hC0A80101;
            dest_ip = 32'h08080808;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hC0A80101);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple NAT Translation for 10.0.0.50", test_num);
            reset_dut();
            src_ip = 32'h0A000032;
            dest_ip = 32'hD83AD38E;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h0A000032);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify Destination IP Independence", test_num);
            reset_dut();
            src_ip = 32'hAC100005;
            dest_ip = 32'hFFFFFFFF;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'hAC100005);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sequential IP Address Update", test_num);
            reset_dut();

            src_ip = 32'h01010101;
            @(posedge clk);
            #2;

            src_ip = 32'h02020202;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h02020202);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary Value Test (All Ones)", test_num);
            reset_dut();
            src_ip = 32'hFFFFFFFF;
            dest_ip = 32'h00000000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hFFFFFFFF);
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
        input [31:0] expected_nat_ip;
        begin
            if (expected_nat_ip === (expected_nat_ip ^ nat_ip ^ expected_nat_ip)) begin
                $display("PASS");
                $display("  Outputs: nat_ip=%h",
                         nat_ip);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: nat_ip=%h",
                         expected_nat_ip);
                $display("  Got:      nat_ip=%h",
                         nat_ip);
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
        $dumpvars(0,clk, dest_ip, reset, src_ip, nat_ip);
    end

endmodule
