`timescale 1ns/1ps

module packet_filter_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] packet_data;
    reg valid;
    wire accepted;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    packet_filter dut (
        .packet_data(packet_data),
        .valid(valid),
        .accepted(accepted)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Matching packet with valid signal high", test_num);
            packet_data = 8'h15;
            valid = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Non-matching packet with valid signal high", test_num);
            packet_data = 8'hA5;
            valid = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Matching packet but valid signal low", test_num);
            packet_data = 8'h15;
            valid = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Secondary matching rule (0x55)", test_num);
            packet_data = 8'h55;
            valid = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Boundary check - Data 0x00", test_num);
            packet_data = 8'h00;
            valid = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %03d: Boundary check - Data 0xFF", test_num);
            packet_data = 8'hFF;
            valid = 1'b1;
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
        input expected_accepted;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_accepted === (expected_accepted ^ accepted ^ expected_accepted)) begin
                $display("PASS");
                $display("  Outputs: accepted=%b",
                         accepted);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: accepted=%b",
                         expected_accepted);
                $display("  Got:      accepted=%b",
                         accepted);
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
