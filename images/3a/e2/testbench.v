`timescale 1ns/1ps

module packet_filter_tb;

    // Testbench signals (combinational circuit)
    reg allow;
    reg [31:0] src_ip;
    wire packet_status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    packet_filter dut (
        .allow(allow),
        .src_ip(src_ip),
        .packet_status(packet_status)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Allow High - Typical IP address", test_num);
            allow = 1'b1;
            src_ip = 32'hC0A80001;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Allow Low - Typical IP address", test_num);
            allow = 1'b0;
            src_ip = 32'hC0A80001;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Allow High - Broadcast IP", test_num);
            allow = 1'b1;
            src_ip = 32'hFFFFFFFF;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Allow Low - Broadcast IP", test_num);
            allow = 1'b0;
            src_ip = 32'hFFFFFFFF;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Allow High - Zero IP", test_num);
            allow = 1'b1;
            src_ip = 32'h00000000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Allow Low - Zero IP", test_num);
            allow = 1'b0;
            src_ip = 32'h00000000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Allow High - Random Pattern", test_num);
            allow = 1'b1;
            src_ip = 32'hA5A55A5A;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Allow Low - Random Pattern", test_num);
            allow = 1'b0;
            src_ip = 32'h5A5AA5A5;
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
        input expected_packet_status;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_packet_status === (expected_packet_status ^ packet_status ^ expected_packet_status)) begin
                $display("PASS");
                $display("  Outputs: packet_status=%b",
                         packet_status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: packet_status=%b",
                         expected_packet_status);
                $display("  Got:      packet_status=%b",
                         packet_status);
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
