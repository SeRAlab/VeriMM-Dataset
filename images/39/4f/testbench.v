`timescale 1ns/1ps

module packet_filter_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] dest_ip;
    reg [7:0] src_ip;
    wire permit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    packet_filter dut (
        .dest_ip(dest_ip),
        .src_ip(src_ip),
        .permit(permit)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Both IP addresses match (Permit Expected)", test_num);

            src_ip = 8'h0A;
            dest_ip = 8'h0B;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Source IP matches, Destination IP mismatches", test_num);
            src_ip = 8'h0A;
            dest_ip = 8'hFF;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Source IP mismatches, Destination IP matches", test_num);
            src_ip = 8'hFF;
            dest_ip = 8'h0B;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Both IP addresses mismatch", test_num);
            src_ip = 8'hEE;
            dest_ip = 8'hDD;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All zeros input", test_num);
            src_ip = 8'h00;
            dest_ip = 8'h00;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All ones input", test_num);
            src_ip = 8'hFF;
            dest_ip = 8'hFF;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bit pattern mismatch", test_num);
            src_ip = 8'h55;
            dest_ip = 8'hAA;
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
