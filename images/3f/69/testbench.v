`timescale 1ns/1ps

module packet_filter_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] dst_ip;
    reg [31:0] src_ip;
    wire accept;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    packet_filter dut (
        .dst_ip(dst_ip),
        .src_ip(src_ip),
        .accept(accept)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Matching Source IP (192.168.1.1)", test_num);
        src_ip = 32'hC0A80101;
        dst_ip = 32'hFFFFFFFF;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Matching Destination IP (10.0.0.1)", test_num);
        src_ip = 32'h00000000;
        dst_ip = 32'h0A000001;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Matching Both Source and Destination IPs", test_num);
        src_ip = 32'hC0A80101;
        dst_ip = 32'h0A000001;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: No Match (Random IPs)", test_num);
        src_ip = 32'h08080808;
        dst_ip = 32'h04040404;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Source IP almost matches (Boundary check)", test_num);
        src_ip = 32'hC0A80102;
        dst_ip = 32'h00000000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Destination IP almost matches (Boundary check)", test_num);
        src_ip = 32'h00000000;
        dst_ip = 32'h0A000002;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: All zeros input", test_num);
        src_ip = 32'h00000000;
        dst_ip = 32'h00000000;
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
