`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg data_commit;
    reg [7:0] data_in;
    reg data_wr;
    reg [1:0] fifoadr;
    reg ifclk;
    reg rd;
    wire [7:0] data;
    wire empty;
    wire send_done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_commit(data_commit),
        .data_in(data_in),
        .data_wr(data_wr),
        .fifoadr(fifoadr),
        .ifclk(ifclk),
        .rd(rd),
        .data(data),
        .empty(empty),
        .send_done(send_done)
    );

    // Clock generation (10ns period)
    initial begin
        ifclk = 0;
        forever #5 ifclk = ~ifclk;
    end

        task reset_dut;

        begin
            @(negedge ifclk);
            data_commit = 1;
            data_wr = 0;
            rd = 0;
            fifoadr = 2'b00;
            data_in = 8'h00;
            repeat (2) @(negedge ifclk);
            data_commit = 0;
            repeat (2) @(negedge ifclk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Write and Read...");
            reset_dut();


            @(negedge ifclk);
            data_in = 8'h55;
            data_wr = 1;
            @(negedge ifclk);
            data_wr = 0;


            repeat (1) @(negedge ifclk);


            rd = 1;
            @(negedge ifclk);


            rd = 0;
            repeat (1) @(negedge ifclk);


            #1;



            check_outputs(8'h55, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Multi-byte Write and Read...");
            reset_dut();


            @(negedge ifclk);
            data_in = 8'hAA;
            data_wr = 1;
            @(negedge ifclk);


            data_in = 8'hBB;
            @(negedge ifclk);
            data_wr = 0;


            @(negedge ifclk);
            rd = 1;
            @(negedge ifclk);


            @(negedge ifclk);

            rd = 0;
            repeat (1) @(negedge ifclk);


            #1;



            check_outputs(8'hBB, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Verify Empty Flag...");
            reset_dut();


            repeat (1) @(negedge ifclk);
            #1;

            check_outputs(8'h00, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Data Commit/Send Done logic...");
            reset_dut();


            @(negedge ifclk);
            data_in = 8'h12;
            data_wr = 1;
            @(negedge ifclk);
            data_wr = 0;


            @(negedge ifclk);
            data_commit = 1;
            @(negedge ifclk);
            data_commit = 0;
            repeat (2) @(negedge ifclk);



            #1;




            check_outputs(8'h00, 1'b1, 1'b1);
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
        input [7:0] expected_data;
        input expected_empty;
        input expected_send_done;
        begin
            if (expected_data === (expected_data ^ data ^ expected_data) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_send_done === (expected_send_done ^ send_done ^ expected_send_done)) begin
                $display("PASS");
                $display("  Outputs: data=%h, empty=%b, send_done=%b",
                         data, empty, send_done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data=%h, empty=%b, send_done=%b",
                         expected_data, expected_empty, expected_send_done);
                $display("  Got:      data=%h, empty=%b, send_done=%b",
                         data, empty, send_done);
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
        $dumpvars(0,data_commit, data_in, data_wr, fifoadr, ifclk, rd, data, empty, send_done);
    end

endmodule
