`timescale 1ns/1ps

module packet_filtering_firewall_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] dest_ip;
    reg [2:0] protocol;
    reg reset;
    reg [4:0] rule_enable;
    reg [31:0] src_ip;
    wire action;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    packet_filtering_firewall dut (
        .clk(clk),
        .dest_ip(dest_ip),
        .protocol(protocol),
        .reset(reset),
        .rule_enable(rule_enable),
        .src_ip(src_ip),
        .action(action)
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
            protocol = 0;
            rule_enable = 0;
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
            reset_dut();
            $display("Test %0d: All Rules Disabled", test_num);


            src_ip = 32'hC0A80101;
            dest_ip = 32'hC0A80102;
            protocol = 3'd1;
            rule_enable = 5'b00000;

            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Match Rule 0 (TCP)", test_num);

            src_ip = 32'h0A000001;
            dest_ip = 32'h0A000002;
            protocol = 3'd6;
            rule_enable = 5'b00001;

            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Match Rule 4 (UDP)", test_num);

            src_ip = 32'hAC100001;
            dest_ip = 32'hAC100002;
            protocol = 3'd4;
            rule_enable = 5'b10000;

            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Valid IPs but Mismatched Protocol", test_num);

            src_ip = 32'h0A000001;
            dest_ip = 32'h0A000002;
            protocol = 3'd0;
            rule_enable = 5'b00001;

            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Valid Dest/Protocol but Mismatched Source IP", test_num);

            src_ip = 32'hFFFFFFFF;
            dest_ip = 32'h0A000002;
            protocol = 3'd6;
            rule_enable = 5'b00001;

            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Multiple Rules Enabled (Match Rule 2)", test_num);

            src_ip = 32'h08080808;
            dest_ip = 32'h08080404;
            protocol = 3'd6;
            rule_enable = 5'b11111;

            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Reset Assertion during match", test_num);

            src_ip = 32'h0A000001;
            dest_ip = 32'h0A000002;
            protocol = 3'd6;
            rule_enable = 5'b00001;

            @(posedge clk);
            reset = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("packet_filtering_firewall Testbench");
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
        input expected_action;
        begin
            if (expected_action === (expected_action ^ action ^ expected_action)) begin
                $display("PASS");
                $display("  Outputs: action=%b",
                         action);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: action=%b",
                         expected_action);
                $display("  Got:      action=%b",
                         action);
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
        $dumpvars(0,clk, dest_ip, protocol, reset, rule_enable, src_ip, action);
    end

endmodule
