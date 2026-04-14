`timescale 1ns/1ps

module ip_checksum_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data_in;
    reg valid;
    wire [15:0] checksum;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ip_checksum dut (
        .data_in(data_in),
        .valid(valid),
        .checksum(checksum),
        .done(done)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single 16-bit word (0x0000)", test_num);
            reset_dut();

            data_in = 16'h0000;
            valid = 1;
            #10;
            valid = 0;


            #10;
            #1;

            check_outputs(16'hFFFF, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Two-word sequence (No carries)", test_num);
            reset_dut();

            valid = 1;
            data_in = 16'h4500; #10;
            data_in = 16'h003C; #10;
            valid = 0;

            #10;
            #1;

            check_outputs(16'hBA63, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Carry-out wrap around (0xFFFF + 0x0001)", test_num);
            reset_dut();

            valid = 1;
            data_in = 16'hFFFF; #10;
            data_in = 16'h0001; #10;
            valid = 0;

            #10;
            #1;

            check_outputs(16'hFFFE, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Maximum values (0xFFFF + 0xFFFF)", test_num);
            reset_dut();

            valid = 1;
            data_in = 16'hFFFF; #10;
            data_in = 16'hFFFF; #10;
            valid = 0;

            #10;
            #1;

            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multi-word sequence", test_num);
            reset_dut();

            valid = 1;
            data_in = 16'h1234; #10;
            data_in = 16'h4321; #10;
            data_in = 16'hABCD; #10;
            valid = 0;

            #10;
            #1;

            check_outputs(16'hFEDC, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiple carries", test_num);
            reset_dut();

            valid = 1;
            data_in = 16'hF000; #10;
            data_in = 16'hF000; #10;
            data_in = 16'hF000; #10;
            valid = 0;

            #10;
            #1;

            check_outputs(16'h2FFD, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ip_checksum Testbench");
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
        input [15:0] expected_checksum;
        input expected_done;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_checksum === (expected_checksum ^ checksum ^ expected_checksum) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: checksum=%h, done=%b",
                         checksum, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: checksum=%h, done=%b",
                         expected_checksum, expected_done);
                $display("  Got:      checksum=%h, done=%b",
                         checksum, done);
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
