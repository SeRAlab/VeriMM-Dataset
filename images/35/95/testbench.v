`timescale 1ns/1ps

module packet_filter_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] dest_ip;
    reg [7:0] src_ip;
    wire accepted;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    packet_filter dut (
        .dest_ip(dest_ip),
        .src_ip(src_ip),
        .accepted(accepted)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Testing src_ip = 191 (Expect Reject)", test_num);
            src_ip = 8'd191;
            dest_ip = 8'h01;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Testing src_ip = 192 (Expect Accept)", test_num);
            src_ip = 8'd192;
            dest_ip = 8'h02;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Testing src_ip = 200 (Expect Accept)", test_num);
            src_ip = 8'd200;
            dest_ip = 8'h03;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Testing src_ip = 223 (Expect Accept)", test_num);
            src_ip = 8'd223;
            dest_ip = 8'h04;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Testing src_ip = 224 (Expect Reject)", test_num);
            src_ip = 8'd224;
            dest_ip = 8'h05;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Testing src_ip = 0 (Expect Reject)", test_num);
            src_ip = 8'd0;
            dest_ip = 8'hFF;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Testing src_ip = 255 (Expect Reject)", test_num);
            src_ip = 8'd255;
            dest_ip = 8'hEE;
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
