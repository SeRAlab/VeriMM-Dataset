`timescale 1ns/1ps

module packet_filter_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] dest_ip;
    reg [7:0] protocol;
    reg [31:0] src_ip;
    wire allow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    packet_filter dut (
        .dest_ip(dest_ip),
        .protocol(protocol),
        .src_ip(src_ip),
        .allow(allow)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Source 192.168.1.10, Dest 10.0.0.1, TCP (Rule 1)", test_num);
            src_ip = 32'hC0A8010A;
            dest_ip = 32'h0A000001;
            protocol = 8'd6;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Source 192.168.1.10, Dest 8.8.8.8, UDP (Rule 1)", test_num);
            src_ip = 32'hC0A8010A;
            dest_ip = 32'h08080808;
            protocol = 8'd17;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Source 192.168.1.20, Dest 10.0.0.1, TCP (Rule 2 Block)", test_num);
            src_ip = 32'hC0A80114;
            dest_ip = 32'h0A000001;
            protocol = 8'd6;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Source 192.168.1.20, Dest 10.0.0.1, UDP (Rule 2 boundary check)", test_num);
            src_ip = 32'hC0A80114;
            dest_ip = 32'h0A000001;
            protocol = 8'd17;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Source 192.168.1.20, Dest 10.0.0.2, TCP (Rule 2 boundary check)", test_num);
            src_ip = 32'hC0A80114;
            dest_ip = 32'h0A000002;
            protocol = 8'd6;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random packet (Rule 3 Default Allow)", test_num);
            src_ip = 32'h01010101;
            dest_ip = 32'h02020202;
            protocol = 8'd6;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Source 192.168.1.21, Dest 10.0.0.1, TCP (Rule 3 Default Allow)", test_num);
            src_ip = 32'hC0A80115;
            dest_ip = 32'h0A000001;
            protocol = 8'd6;
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
        input expected_allow;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_allow === (expected_allow ^ allow ^ expected_allow)) begin
                $display("PASS");
                $display("  Outputs: allow=%b",
                         allow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: allow=%b",
                         expected_allow);
                $display("  Got:      allow=%b",
                         allow);
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
