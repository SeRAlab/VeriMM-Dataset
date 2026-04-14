`timescale 1ns/1ps

module nat_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] internal_ip;
    reg rst;
    wire [31:0] external_ip;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nat dut (
        .clk(clk),
        .internal_ip(internal_ip),
        .rst(rst),
        .external_ip(external_ip)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            internal_ip = 32'h0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mapping 192.168.1.1", test_num);
            reset_dut();
            internal_ip = 32'hC0A80101;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0A000001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mapping 192.168.1.2", test_num);
            reset_dut();
            internal_ip = 32'hC0A80102;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0A000002);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Unknown IP (Default Mapping)", test_num);
            reset_dut();
            internal_ip = 32'h0A000005;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mapping 192.168.1.3", test_num);
            reset_dut();
            internal_ip = 32'hC0A80103;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0A000003);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Post-Reset Default Check", test_num);
            reset_dut();
            internal_ip = 32'h00000000;
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
        input [31:0] expected_external_ip;
        begin
            if (expected_external_ip === (expected_external_ip ^ external_ip ^ expected_external_ip)) begin
                $display("PASS");
                $display("  Outputs: external_ip=%h",
                         external_ip);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: external_ip=%h",
                         expected_external_ip);
                $display("  Got:      external_ip=%h",
                         external_ip);
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
        $dumpvars(0,clk, internal_ip, rst, external_ip);
    end

endmodule
