`timescale 1ns/1ps

module checksum_checker_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] data_in;
    reg valid;
    wire [3:0] checksum_out;
    wire integrity_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    checksum_checker dut (
        .data_in(data_in),
        .valid(valid),
        .checksum_out(checksum_out),
        .integrity_valid(integrity_valid)
    );

    // Clock generation (10ns period)
    initial begin
        valid = 0;
        forever #5 valid = ~valid;
    end

        task reset_dut;

        begin
            data_in = 4'b0000;
            repeat(2) @(posedge valid);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %03d: Data=4'b0000 (Expected: Sum=0, Valid=1)", test_num);
            data_in = 4'b0000;
            repeat(2) @(posedge valid);
            #1;
            #1;

            check_outputs(4'd0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %03d: Data=4'b0001 (Expected: Sum=1, Valid=1)", test_num);
            data_in = 4'b0001;
            repeat(2) @(posedge valid);
            #1;
            #1;

            check_outputs(4'd1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %03d: Data=4'b0010 (Expected: Sum=1, Valid=0)", test_num);
            data_in = 4'b0010;
            repeat(2) @(posedge valid);
            #1;
            #1;

            check_outputs(4'd1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %03d: Data=4'b0011 (Expected: Sum=2, Valid=0)", test_num);
            data_in = 4'b0011;
            repeat(2) @(posedge valid);
            #1;
            #1;

            check_outputs(4'd2, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %03d: Data=4'b0111 (Expected: Sum=3, Valid=0)", test_num);
            data_in = 4'b0111;
            repeat(2) @(posedge valid);
            #1;
            #1;

            check_outputs(4'd3, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %03d: Data=4'b1111 (Expected: Sum=4, Valid=0)", test_num);
            data_in = 4'b1111;
            repeat(2) @(posedge valid);
            #1;
            #1;

            check_outputs(4'd4, 1'b0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %03d: Data=4'b1010 (Expected: Sum=2, Valid=0)", test_num);
            data_in = 4'b1010;
            repeat(2) @(posedge valid);
            #1;
            #1;

            check_outputs(4'd2, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("checksum_checker Testbench");
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
        input [3:0] expected_checksum_out;
        input expected_integrity_valid;
        begin
            if (expected_checksum_out === (expected_checksum_out ^ checksum_out ^ expected_checksum_out) &&
                expected_integrity_valid === (expected_integrity_valid ^ integrity_valid ^ expected_integrity_valid)) begin
                $display("PASS");
                $display("  Outputs: checksum_out=%h, integrity_valid=%b",
                         checksum_out, integrity_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: checksum_out=%h, integrity_valid=%b",
                         expected_checksum_out, expected_integrity_valid);
                $display("  Got:      checksum_out=%h, integrity_valid=%b",
                         checksum_out, integrity_valid);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,data_in, valid, checksum_out, integrity_valid);
    end

endmodule
