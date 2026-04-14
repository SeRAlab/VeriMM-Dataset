`timescale 1ns/1ps

module pcie_tx_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg reset;
    reg start_read;
    reg start_write;
    wire [31:0] data_out;
    wire transaction_status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_tx_controller dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .start_read(start_read),
        .start_write(start_write),
        .data_out(data_out),
        .transaction_status(transaction_status)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start_read = 0;
            start_write = 0;
            data_in = 32'h0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(32'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Single Write Operation", test_num);
            reset_dut();

            data_in = 32'hA5A5A5A5;
            start_write = 1;
            @(posedge clk);
            start_write = 0;


            repeat(2) @(posedge clk);



            #1;




            check_outputs(32'h0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Single Read Operation (Initial)", test_num);
            reset_dut();

            start_read = 1;
            @(posedge clk);
            start_read = 0;

            repeat(2) @(posedge clk);


            #1;



            check_outputs(32'h0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Write then Read Sequence", test_num);
            reset_dut();


            data_in = 32'h12345678;
            start_write = 1;
            @(posedge clk);
            start_write = 0;
            repeat(2) @(posedge clk);


            start_read = 1;
            @(posedge clk);
            start_read = 0;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(32'h12345678, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Multiple Writes", test_num);
            reset_dut();


            data_in = 32'hDEADC0DE;
            start_write = 1;
            @(posedge clk);
            start_write = 0;
            repeat(1) @(posedge clk);


            data_in = 32'hBEEFBEEF;
            start_write = 1;
            @(posedge clk);
            start_write = 0;
            repeat(2) @(posedge clk);


            start_read = 1;
            @(posedge clk);
            start_read = 0;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(32'hBEEFBEEF, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_tx_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input expected_transaction_status;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_transaction_status === (expected_transaction_status ^ transaction_status ^ expected_transaction_status)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, transaction_status=%b",
                         data_out, transaction_status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, transaction_status=%b",
                         expected_data_out, expected_transaction_status);
                $display("  Got:      data_out=%h, transaction_status=%b",
                         data_out, transaction_status);
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
        $dumpvars(0,clk, data_in, reset, start_read, start_write, data_out, transaction_status);
    end

endmodule
