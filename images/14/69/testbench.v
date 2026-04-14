`timescale 1ns/1ps

module packet_filter_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] dest_port;
    reg [31:0] src_ip;
    wire permit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    packet_filter dut (
        .dest_port(dest_port),
        .src_ip(src_ip),
        .permit(permit)
    );
    task testcase001;

        begin
            test_num = 1;
            src_ip = 32'hC0A80101;
            dest_port = 16'd80;
            $display("Testcase %0d: Rule 1 - 192.168.1.1 to port 80", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            src_ip = 32'hC0A80101;
            dest_port = 16'd443;
            $display("Testcase %0d: Rule 1 - 192.168.1.1 to port 443", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            src_ip = 32'h0A000001;
            dest_port = 16'd80;
            $display("Testcase %0d: Rule 2 - 10.0.0.1 to port 80 (Deny)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            src_ip = 32'h0A000001;
            dest_port = 16'd22;
            $display("Testcase %0d: Rule 2 IP but different port (10.0.0.1 to 22)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            src_ip = 32'h08080808;
            dest_port = 16'd53;
            $display("Testcase %0d: Rule 3 - Random IP (8.8.8.8 to 53)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            src_ip = 32'hAC100001;
            dest_port = 16'd80;
            $display("Testcase %0d: Rule 3 - Random IP (172.16.0.1 to 80)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            src_ip = 32'hFFFFFFFF;
            dest_port = 16'd65535;
            $display("Testcase %0d: Boundary - All ones IP/Port", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            src_ip = 32'h00000000;
            dest_port = 16'd0;
            $display("Testcase %0d: Boundary - All zeros IP/Port", test_num);
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
