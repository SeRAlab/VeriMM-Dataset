`timescale 1ns/1ps

module packet_filter_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] dest_port;
    reg [7:0] protocol;
    reg [31:0] src_ip;
    wire accept;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    packet_filter dut (
        .dest_port(dest_port),
        .protocol(protocol),
        .src_ip(src_ip),
        .accept(accept)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Rule 1 Match (Exact)", test_num);
            src_ip = 32'hC0A80101;
            dest_port = 16'd80;
            protocol = 8'd6;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Rule 2 Match (Protocol 6)", test_num);
            src_ip = 32'h0A000005;
            dest_port = 16'd443;
            protocol = 8'd6;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Rule 2 Match (Protocol 17)", test_num);
            src_ip = 32'h0A000005;
            dest_port = 16'd443;
            protocol = 8'd17;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Rule 1 Fail (Wrong Protocol)", test_num);
            src_ip = 32'hC0A80101;
            dest_port = 16'd80;
            protocol = 8'd17;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Rule 1 Fail (Wrong Port)", test_num);
            src_ip = 32'hC0A80101;
            dest_port = 16'd8080;
            protocol = 8'd6;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Rule 2 Fail (Wrong Port)", test_num);
            src_ip = 32'h0A000005;
            dest_port = 16'd80;
            protocol = 8'd6;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: General Reject (Random Data)", test_num);
            src_ip = 32'h08080808;
            dest_port = 16'd53;
            protocol = 8'd17;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Borderline IP Mismatch", test_num);
            src_ip = 32'hC0A80102;
            dest_port = 16'd80;
            protocol = 8'd6;
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
        input expected_accept;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_accept === (expected_accept ^ accept ^ expected_accept)) begin
                $display("PASS");
                $display("  Outputs: accept=%b",
                         accept);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: accept=%b",
                         expected_accept);
                $display("  Got:      accept=%b",
                         accept);
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
