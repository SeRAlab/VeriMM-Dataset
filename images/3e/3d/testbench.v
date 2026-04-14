`timescale 1ns/1ps

module packet_filter_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] filter;
    reg [7:0] packet;
    reg reset;
    wire match;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    packet_filter dut (
        .filter(filter),
        .packet(packet),
        .reset(reset),
        .match(match)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            reset = 1'b1;
            filter = 8'hA5;
            packet = 8'hA5;
            $display("Test Case %0d: Reset Active Override (Filter: %h, Packet: %h)", test_num, filter, packet);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset = 1'b0;
            filter = 8'h5A;
            packet = 8'h5A;
            $display("Test Case %0d: Basic Match (Filter: %h, Packet: %h)", test_num, filter, packet);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset = 1'b0;
            filter = 8'hFF;
            packet = 8'h00;
            $display("Test Case %0d: Basic Mismatch (Filter: %h, Packet: %h)", test_num, filter, packet);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset = 1'b0;
            filter = 8'h00;
            packet = 8'h00;
            $display("Test Case %0d: All Zeros Match", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset = 1'b0;
            filter = 8'hFF;
            packet = 8'hFF;
            $display("Test Case %0d: All Ones Match", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset = 1'b0;
            filter = 8'hFE;
            packet = 8'hFF;
            $display("Test Case %0d: LSB Mismatch (Filter: %h, Packet: %h)", test_num, filter, packet);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset = 1'b0;
            filter = 8'h7F;
            packet = 8'hFF;
            $display("Test Case %0d: MSB Mismatch (Filter: %h, Packet: %h)", test_num, filter, packet);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset = 1'b1;
            filter = 8'h12;
            packet = 8'h34;
            $display("Test Case %0d: Reset Active with Mismatch (Filter: %h, Packet: %h)", test_num, filter, packet);
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
        input expected_match;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_match === (expected_match ^ match ^ expected_match)) begin
                $display("PASS");
                $display("  Outputs: match=%b",
                         match);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: match=%b",
                         expected_match);
                $display("  Got:      match=%b",
                         match);
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
