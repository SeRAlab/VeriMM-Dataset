`timescale 1ns/1ps

module PacketFilter_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] dest_port;
    reg enable;
    reg [31:0] src_ip;
    wire allowed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    PacketFilter dut (
        .dest_port(dest_port),
        .enable(enable),
        .src_ip(src_ip),
        .allowed(allowed)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Filter Disabled", test_num);
            enable = 0;
            src_ip = 32'hC0A80101;
            dest_port = 16'd85;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Successful Match (Middle of range)", test_num);
            enable = 1;
            src_ip = 32'hC0A80101;
            dest_port = 16'd90;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Port Out of Range (Too Low)", test_num);
            enable = 1;
            src_ip = 32'hC0A80101;
            dest_port = 16'd79;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Port Out of Range (Too High)", test_num);
            enable = 1;
            src_ip = 32'hC0A80101;
            dest_port = 16'd101;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Mismatched IP Address", test_num);
            enable = 1;
            src_ip = 32'h0A000001;
            dest_port = 16'd85;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Port Boundary Match (Minimum)", test_num);
            enable = 1;
            src_ip = 32'hC0A80101;
            dest_port = 16'd80;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Port Boundary Match (Maximum)", test_num);
            enable = 1;
            src_ip = 32'hC0A80101;
            dest_port = 16'd100;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Conditions Wrong", test_num);
            enable = 1;
            src_ip = 32'hFFFFFFFF;
            dest_port = 16'hFFFF;
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
        $display("PacketFilter Testbench");
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
