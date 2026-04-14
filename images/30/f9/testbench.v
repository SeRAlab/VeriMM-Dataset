`timescale 1ns/1ps

module data_forwarding_unit_tb;

    // Testbench signals (combinational circuit)
    reg forwardA;
    reg forwardB;
    reg [31:0] source1;
    reg [31:0] source2;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    data_forwarding_unit dut (
        .forwardA(forwardA),
        .forwardB(forwardB),
        .source1(source1),
        .source2(source2),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Forward from Source 1 (forwardA=1, forwardB=0)", test_num);
            source1 = 32'hDEADBEEF;
            source2 = 32'hCAFEBABE;
            forwardA = 1'b1;
            forwardB = 1'b0;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Forward from Source 2 (forwardA=0, forwardB=1)", test_num);
            source1 = 32'h12345678;
            source2 = 32'h87654321;
            forwardA = 1'b0;
            forwardB = 1'b1;
            #1;

            check_outputs(32'h87654321);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: No forwarding selected (forwardA=0, forwardB=0)", test_num);
            source1 = 32'hAAAA_AAAA;
            source2 = 32'hBBBB_BBBB;
            forwardA = 1'b0;
            forwardB = 1'b0;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Priority Check - Both signals active (forwardA=1, forwardB=1)", test_num);

            source1 = 32'hFFFF_0000;
            source2 = 32'h0000_FFFF;
            forwardA = 1'b1;
            forwardB = 1'b1;
            #1;

            check_outputs(32'hFFFF_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternate data patterns with Source 2", test_num);
            source1 = 32'h5555_5555;
            source2 = 32'hAAAA_AAAA;
            forwardA = 1'b0;
            forwardB = 1'b1;
            #1;

            check_outputs(32'hAAAA_AAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large values with Source 1", test_num);
            source1 = 32'hFFFF_FFFF;
            source2 = 32'h0000_0000;
            forwardA = 1'b1;
            forwardB = 1'b0;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("data_forwarding_unit Testbench");
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
        input [31:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
