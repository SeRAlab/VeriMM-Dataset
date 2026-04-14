`timescale 1ns/1ps

module packet_filter_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] filter;
    reg [7:0] packet;
    wire fail;
    wire pass;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    packet_filter dut (
        .filter(filter),
        .packet(packet),
        .fail(fail),
        .pass(pass)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All-zero match", test_num);
            filter = 8'h00;
            packet = 8'h00;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All-ones match", test_num);
            filter = 8'hFF;
            packet = 8'hFF;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Arbitrary pattern match", test_num);
            filter = 8'hA5;
            packet = 8'hA5;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mismatch - LSB difference", test_num);
            filter = 8'hF0;
            packet = 8'hF1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mismatch - MSB difference", test_num);
            filter = 8'h7F;
            packet = 8'hFF;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mismatch - Inverse patterns", test_num);
            filter = 8'hAA;
            packet = 8'h55;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mismatch - Zero vs Non-zero", test_num);
            filter = 8'h00;
            packet = 8'h01;
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
        input expected_fail;
        input expected_pass;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_fail === (expected_fail ^ fail ^ expected_fail) &&
                expected_pass === (expected_pass ^ pass ^ expected_pass)) begin
                $display("PASS");
                $display("  Outputs: fail=%b, pass=%b",
                         fail, pass);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fail=%b, pass=%b",
                         expected_fail, expected_pass);
                $display("  Got:      fail=%b, pass=%b",
                         fail, pass);
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
