`timescale 1ns/1ps

module packet_filter_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] dst_ip;
    reg [1:0] protocol;
    reg [31:0] src_ip;
    wire permit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    packet_filter dut (
        .dst_ip(dst_ip),
        .protocol(protocol),
        .src_ip(src_ip),
        .permit(permit)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Rule 1 Match (192.168.1.1, TCP)", test_num);
            src_ip = 32'hC0A80101;
            dst_ip = 32'h08080808;
            protocol = 2'b00;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Rule 2 Match (10.0.0.5, UDP)", test_num);
            src_ip = 32'h01010101;
            dst_ip = 32'h0A000005;
            protocol = 2'b01;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Rule 1 IP Match, Wrong Protocol (UDP)", test_num);
            src_ip = 32'hC0A80101;
            dst_ip = 32'h01010101;
            protocol = 2'b01;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Rule 2 IP Match, Wrong Protocol (TCP)", test_num);
            src_ip = 32'h01010101;
            dst_ip = 32'h0A000005;
            protocol = 2'b00;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Totally Random Packet", test_num);
            src_ip = 32'hAC100001;
            dst_ip = 32'h08080404;
            protocol = 2'b10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Rule 1 Match with different destination", test_num);
            src_ip = 32'hC0A80101;
            dst_ip = 32'hFFFFFFFF;
            protocol = 2'b00;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Rule 2 Match with different source", test_num);
            src_ip = 32'h00000000;
            dst_ip = 32'h0A000005;
            protocol = 2'b01;
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
        input expected_permit;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_permit === (expected_permit ^ permit ^ expected_permit)) begin
                $display("PASS");
                $display("  Outputs: permit=%b",
                         permit);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: permit=%b",
                         expected_permit);
                $display("  Got:      permit=%b",
                         permit);
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
