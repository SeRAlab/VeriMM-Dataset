`timescale 1ns/1ps

module packet_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] dest_ip;
    reg [7:0] port;
    reg rst;
    reg rule_enable;
    reg [7:0] src_ip;
    wire packet_allowed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    packet_filter dut (
        .clk(clk),
        .dest_ip(dest_ip),
        .port(port),
        .rst(rst),
        .rule_enable(rule_enable),
        .src_ip(src_ip),
        .packet_allowed(packet_allowed)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            src_ip = 0;
            dest_ip = 0;
            port = 0;
            rule_enable = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Exact match with rule enabled", test_num);
            src_ip = 8'd152;
            dest_ip = 8'd213;
            port = 8'd56;
            rule_enable = 1'b1;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Exact match but rule disabled", test_num);
            src_ip = 8'd152;
            dest_ip = 8'd213;
            port = 8'd56;
            rule_enable = 1'b0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Mismatched Source IP", test_num);
            src_ip = 8'd100;
            dest_ip = 8'd213;
            port = 8'd56;
            rule_enable = 1'b1;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Mismatched Destination IP", test_num);
            src_ip = 8'd152;
            dest_ip = 8'd0;
            port = 8'd56;
            rule_enable = 1'b1;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Mismatched Port", test_num);
            src_ip = 8'd152;
            dest_ip = 8'd213;
            port = 8'd80;
            rule_enable = 1'b1;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: All fields mismatch", test_num);
            src_ip = 8'hFF;
            dest_ip = 8'hAA;
            port = 8'h01;
            rule_enable = 1'b1;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Testcase %0d: Input all zeros, rule enabled", test_num);
            src_ip = 8'h00;
            dest_ip = 8'h00;
            port = 8'h00;
            rule_enable = 1'b1;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin

            test_num = 8;
            $display("Testcase %0d: Check output during active reset", test_num);
            src_ip = 8'd152;
            dest_ip = 8'd213;
            port = 8'd56;
            rule_enable = 1'b1;
            rst = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
            rst = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("packet_filter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input expected_packet_allowed;
        begin
            if (expected_packet_allowed === (expected_packet_allowed ^ packet_allowed ^ expected_packet_allowed)) begin
                $display("PASS");
                $display("  Outputs: packet_allowed=%b",
                         packet_allowed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: packet_allowed=%b",
                         expected_packet_allowed);
                $display("  Got:      packet_allowed=%b",
                         packet_allowed);
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
        $dumpvars(0,clk, dest_ip, port, rst, rule_enable, src_ip, packet_allowed);
    end

endmodule
