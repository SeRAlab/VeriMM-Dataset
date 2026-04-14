`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data_count;
    reg [2:0] state;
    wire empty;
    wire full;
    wire rd_ack;
    wire rd_err;
    wire wr_ack;
    wire wr_err;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_count(data_count),
        .state(state),
        .empty(empty),
        .full(full),
        .rd_ack(rd_ack),
        .rd_err(rd_err),
        .wr_ack(wr_ack),
        .wr_err(wr_err)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Checking Empty Status (data_count=0)", test_num);
        data_count = 4'd0;
        state = 3'b000;
        #1;

        check_outputs(1, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Checking Full Status (data_count=8)", test_num);
        data_count = 4'd8;
        state = 3'b000;
        #1;

        check_outputs(0, 1, 0, 0, 0, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Checking Mid-range (data_count=4)", test_num);
        data_count = 4'd4;
        state = 3'b000;
        #1;

        check_outputs(0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Checking Write Acknowledge (state=1)", test_num);
        data_count = 4'd1;
        state = 3'b001;
        #1;

        check_outputs(0, 0, 0, 0, 1, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Checking Write Error (state=2)", test_num);
        data_count = 4'd8;
        state = 3'b010;
        #1;

        check_outputs(0, 1, 0, 0, 0, 1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Checking Read Acknowledge (state=3)", test_num);
        data_count = 4'd7;
        state = 3'b011;
        #1;

        check_outputs(0, 0, 1, 0, 0, 0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Checking Read Error (state=4)", test_num);
        data_count = 4'd0;
        state = 3'b100;
        #1;

        check_outputs(1, 0, 0, 1, 0, 0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %03d: Checking Overflow Boundary (data_count=15)", test_num);
        data_count = 4'd15;
        state = 3'b000;

        #1;


        check_outputs(0, 0, 0, 0, 0, 0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input expected_empty;
        input expected_full;
        input expected_rd_ack;
        input expected_rd_err;
        input expected_wr_ack;
        input expected_wr_err;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_rd_ack === (expected_rd_ack ^ rd_ack ^ expected_rd_ack) &&
                expected_rd_err === (expected_rd_err ^ rd_err ^ expected_rd_err) &&
                expected_wr_ack === (expected_wr_ack ^ wr_ack ^ expected_wr_ack) &&
                expected_wr_err === (expected_wr_err ^ wr_err ^ expected_wr_err)) begin
                $display("PASS");
                $display("  Outputs: empty=%b, full=%b, rd_ack=%b, rd_err=%b, wr_ack=%b, wr_err=%b",
                         empty, full, rd_ack, rd_err, wr_ack, wr_err);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: empty=%b, full=%b, rd_ack=%b, rd_err=%b, wr_ack=%b, wr_err=%b",
                         expected_empty, expected_full, expected_rd_ack, expected_rd_err, expected_wr_ack, expected_wr_err);
                $display("  Got:      empty=%b, full=%b, rd_ack=%b, rd_err=%b, wr_ack=%b, wr_err=%b",
                         empty, full, rd_ack, rd_err, wr_ack, wr_err);
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
