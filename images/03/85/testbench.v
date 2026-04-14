`timescale 1ns/1ps

module packet_filter_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] allowed_dest_addr;
    reg [15:0] allowed_src_addr;
    reg [15:0] dest_addr;
    reg [15:0] src_addr;
    wire allow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    packet_filter dut (
        .allowed_dest_addr(allowed_dest_addr),
        .allowed_src_addr(allowed_src_addr),
        .dest_addr(dest_addr),
        .src_addr(src_addr),
        .allow(allow)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Exact Match (src and dest match allowed addresses)", test_num);
            allowed_src_addr = 16'h1234;
            allowed_dest_addr = 16'h5678;
            src_addr = 16'h1234;
            dest_addr = 16'h5678;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Source Address Mismatch", test_num);
            allowed_src_addr = 16'h1234;
            allowed_dest_addr = 16'h5678;
            src_addr = 16'hAAAA;
            dest_addr = 16'h5678;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Destination Address Mismatch", test_num);
            allowed_src_addr = 16'h1234;
            allowed_dest_addr = 16'h5678;
            src_addr = 16'h1234;
            dest_addr = 16'hBBBB;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Both Addresses Mismatch", test_num);
            allowed_src_addr = 16'h1234;
            allowed_dest_addr = 16'h5678;
            src_addr = 16'hFFFF;
            dest_addr = 16'h0000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: All Zeros Match", test_num);
            allowed_src_addr = 16'h0000;
            allowed_dest_addr = 16'h0000;
            src_addr = 16'h0000;
            dest_addr = 16'h0000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: All Ones Match", test_num);
            allowed_src_addr = 16'hFFFF;
            allowed_dest_addr = 16'hFFFF;
            src_addr = 16'hFFFF;
            dest_addr = 16'hFFFF;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Partial Bit Mismatch (Source)", test_num);
            allowed_src_addr = 16'h0001;
            allowed_dest_addr = 16'h8000;
            src_addr = 16'h0000;
            dest_addr = 16'h8000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Partial Bit Mismatch (Destination)", test_num);
            allowed_src_addr = 16'hAAAA;
            allowed_dest_addr = 16'h5555;
            src_addr = 16'hAAAA;
            dest_addr = 16'h5554;
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
