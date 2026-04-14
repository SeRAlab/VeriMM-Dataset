`timescale 1ns/1ps

module I2C_Master_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg start;
    wire ack;
    wire busy;
    wire scl;
    wire sda;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    I2C_Master dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .start(start),
        .ack(ack),
        .busy(busy),
        .scl(scl),
        .sda(sda)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("Resetting DUT...");
            reset = 1;
            start = 0;
            data_in = 8'h00;
            repeat(5) @(posedge clk);
            reset = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task wait_for_completion;

        begin

            wait(busy == 1);

            wait(busy == 0);

            repeat(20) @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Transmitting 0xA5 (10100101)", test_num);
            reset_dut();

            data_in = 8'hA5;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait_for_completion();





            #1;






            check_outputs(1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Transmitting 0x00", test_num);
            reset_dut();

            data_in = 8'h00;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait_for_completion();


            #1;



            check_outputs(1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Transmitting 0xFF", test_num);
            reset_dut();

            data_in = 8'hFF;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait_for_completion();


            #1;



            check_outputs(1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Transmitting 0x5A", test_num);
            reset_dut();

            data_in = 8'h5A;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait_for_completion();


            #1;



            check_outputs(1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("I2C_Master Testbench");
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
        input expected_ack;
        input expected_busy;
        input expected_scl;
        input expected_sda;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_scl === (expected_scl ^ scl ^ expected_scl) &&
                expected_sda === (expected_sda ^ sda ^ expected_sda)) begin
                $display("PASS");
                $display("  Outputs: ack=%b, busy=%b, scl=%b, sda=%b",
                         ack, busy, scl, sda);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%b, busy=%b, scl=%b, sda=%b",
                         expected_ack, expected_busy, expected_scl, expected_sda);
                $display("  Got:      ack=%b, busy=%b, scl=%b, sda=%b",
                         ack, busy, scl, sda);
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
        $dumpvars(0,clk, data_in, reset, start, ack, busy, scl, sda);
    end

endmodule
