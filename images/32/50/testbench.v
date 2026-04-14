`timescale 1ns/1ps

module packet_filter_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] dest_ip;
    reg [2:0] proto;
    reg [31:0] src_ip;
    wire deny;
    wire permit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    packet_filter dut (
        .dest_ip(dest_ip),
        .proto(proto),
        .src_ip(src_ip),
        .deny(deny),
        .permit(permit)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Matching Packet (Permit)", test_num);
            src_ip  = 32'hC0A80101;
            dest_ip = 32'h0A000001;
            proto   = 3'b001;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Wrong Source IP (Deny)", test_num);
            src_ip  = 32'hC0A80102;
            dest_ip = 32'h0A000001;
            proto   = 3'b001;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Wrong Destination IP (Deny)", test_num);
            src_ip  = 32'hC0A80101;
            dest_ip = 32'h0A000002;
            proto   = 3'b001;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Wrong Protocol (Deny)", test_num);
            src_ip  = 32'hC0A80101;
            dest_ip = 32'h0A000001;
            proto   = 3'b010;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Boundary IP bits (Deny)", test_num);
            src_ip  = 32'hC0A80101 ^ 32'h00000001;
            dest_ip = 32'h0A000001;
            proto   = 3'b001;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All fields incorrect (Deny)", test_num);
            src_ip  = 32'hFFFFFFFF;
            dest_ip = 32'h00000000;
            proto   = 3'b111;
            #1;

            check_outputs(1'b1, 1'b0);
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
        input expected_deny;
        input expected_permit;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_deny === (expected_deny ^ deny ^ expected_deny) &&
                expected_permit === (expected_permit ^ permit ^ expected_permit)) begin
                $display("PASS");
                $display("  Outputs: deny=%b, permit=%b",
                         deny, permit);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: deny=%b, permit=%b",
                         expected_deny, expected_permit);
                $display("  Got:      deny=%b, permit=%b",
                         deny, permit);
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
