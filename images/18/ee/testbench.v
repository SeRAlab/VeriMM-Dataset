`timescale 1ns/1ps

module packet_filter_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] dest_ip;
    reg enable;
    reg [3:0] protocol;
    reg [31:0] src_ip;
    wire allowed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    packet_filter dut (
        .dest_ip(dest_ip),
        .enable(enable),
        .protocol(protocol),
        .src_ip(src_ip),
        .allowed(allowed)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Rule 1 Match (192.168.1.1, TCP)", test_num);
            src_ip   = 32'hC0A80101;
            dest_ip  = 32'h08080808;
            protocol = 4'd6;
            enable   = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Rule 2 Match (10.0.0.1, UDP)", test_num);
            src_ip   = 32'h0A000001;
            dest_ip  = 32'hC0A80105;
            protocol = 4'd17;
            enable   = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Rule 3 Default Allow (Random Packet)", test_num);
            src_ip   = 32'hAC100001;
            dest_ip  = 32'hAC100002;
            protocol = 4'd1;
            enable   = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Rule 3 (10.0.0.1, but Protocol TCP)", test_num);
            src_ip   = 32'h0A000001;
            dest_ip  = 32'h08080808;
            protocol = 4'd6;
            enable   = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Rule 3 (192.168.1.1, but Protocol UDP)", test_num);
            src_ip   = 32'hC0A80101;
            dest_ip  = 32'h0A000005;
            protocol = 4'd17;
            enable   = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Filtering Disabled (Bypass Deny Rule)", test_num);
            src_ip   = 32'h0A000001;
            dest_ip  = 32'h08080808;
            protocol = 4'd17;
            enable   = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Rule 1 with different Destination IP", test_num);
            src_ip   = 32'hC0A80101;
            dest_ip  = 32'hFFFFFFFF;
            protocol = 4'd6;
            enable   = 1'b1;
            #1;

            check_outputs(1'b1);
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
        input expected_allowed;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_allowed === (expected_allowed ^ allowed ^ expected_allowed)) begin
                $display("PASS");
                $display("  Outputs: allowed=%b",
                         allowed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: allowed=%b",
                         expected_allowed);
                $display("  Got:      allowed=%b",
                         allowed);
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

endmodule
