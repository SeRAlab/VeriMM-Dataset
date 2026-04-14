`timescale 1ns/1ps

module pcie_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg start_read;
    reg start_write;
    wire [1:0] state;
    wire transaction_done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_controller dut (
        .clk(clk),
        .reset(reset),
        .start_read(start_read),
        .start_write(start_write),
        .state(state),
        .transaction_done(transaction_done)
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
        @(posedge clk);
        #2 reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Reset and IDLE Check", test_num);
        reset_dut();

        #1;


        check_outputs(2'b00, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Read Transaction", test_num);
        reset_dut();

        start_read = 1;
        @(posedge clk);
        #1 start_read = 0;

        @(posedge clk);
        #1;


        #1;



        check_outputs(2'b00, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Write Transaction", test_num);
        reset_dut();

        start_write = 1;
        @(posedge clk);
        #1 start_write = 0;

        @(posedge clk);
        #1;


        #1;



        check_outputs(2'b00, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Simultaneous Read/Write Request", test_num);
        reset_dut();

        start_read = 1;
        start_write = 1;
        @(posedge clk);
        #1;
        start_read = 0;
        start_write = 0;

        @(posedge clk);
        #1;


        #1;



        check_outputs(2'b00, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Back-to-Back Transactions", test_num);
        reset_dut();


        start_read = 1;
        @(posedge clk);
        #1 start_read = 0;
        @(posedge clk);
        #1;


        start_write = 1;
        @(posedge clk);
        #1 start_write = 0;
        @(posedge clk);
        #1;


        #1;



        check_outputs(2'b00, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_controller Testbench");
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
        input [1:0] expected_state;
        input expected_transaction_done;
        begin
            if (expected_state === (expected_state ^ state ^ expected_state) &&
                expected_transaction_done === (expected_transaction_done ^ transaction_done ^ expected_transaction_done)) begin
                $display("PASS");
                $display("  Outputs: state=%h, transaction_done=%b",
                         state, transaction_done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: state=%h, transaction_done=%b",
                         expected_state, expected_transaction_done);
                $display("  Got:      state=%h, transaction_done=%b",
                         state, transaction_done);
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
        $dumpvars(0,clk, reset, start_read, start_write, state, transaction_done);
    end

endmodule
